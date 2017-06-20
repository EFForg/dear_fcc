require "spec_helper"

describe EcfsWorker do
  let(:payload) { { key: "the payload is opaque" } }
  describe ".submit_comment" do
    let(:confirmation) do
      double(fcc_confirm_id: response.fetch("confirm"), fcc_received: response.fetch("received"))
    end

    let(:response) {
      { "confirm" => Time.now.strftime("%Y%m%d%H%M%S%L"),
        "received" => Time.now.strftime("%FT%T%:z") }
    }

    let(:filings_api) {
      "https://publicapi.fcc.gov/ecfs/filings?api_key=#{ENV['ECFS_API_KEY']}"
    }

    it "should POST to the ECFS api and create a Confirmation out of the response" do
      stub_request(:post, filings_api).
        with(body: payload.to_json).
        to_return(status: 200, body: response.to_json)

      expect(Confirmation).to receive(:create){ confirmation }

      record = EcfsWorker.submit_comment(payload)
      expect(record.fcc_confirm_id).to eq(response.fetch("confirm"))
      expect(record.fcc_received).to eq(response.fetch("received"))
    end

    it "should raise EcfsWorker::Error if the request is not successful" do
      stub_request(:post, filings_api).
        with(body: payload.to_json).
        to_return(status: 500, body: response.to_json)

      expect(Confirmation).not_to receive(:create)
      expect{ EcfsWorker.submit_comment(payload) }.to raise_error(EcfsWorker::Error)
    end
  end

  describe ".submit_comment_by_id" do
    it "should lookup the comment and give the payload to submit_comment, then save the confirmation" do
      comment = double(id: rand(1000000), payload: payload)
      expect(Comment).to receive(:find).with(comment.id){ comment }

      confirmation = double(id: rand(1000000))
      expect(EcfsWorker).to receive(:submit_comment).with(comment.payload){ confirmation }
      expect(comment).to receive(:update_column).with(:confirmation_id, confirmation.id)

      EcfsWorker.submit_comment_by_id(comment.id)
    end
  end
end

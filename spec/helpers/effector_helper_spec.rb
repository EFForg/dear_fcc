require "spec_helper"

app_class = Class.new
app_class.include(DearFcc::App::EffectorHelper)

describe DearFcc::App::EffectorHelper do
  let(:filer){ { "email" => "user@example.com", "zip_code" => "12345" } }

  describe '#send_thank_you_email(filer)' do
    it "should delay a call to CivicrmWorker.send_thank_you_email" do
      delayed_worker = double("delayed_worker")

      expect(CivicrmWorker).to receive(:delay){ delayed_worker }
      expect(delayed_worker).to receive(:send_thank_you_email).
                                 with(filer["email"], { zip_code: filer["zip_code"], subscribe: false })

      app_class.new.send_thank_you_email(filer)
    end
  end
end

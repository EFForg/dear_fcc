require "spec_helper"

app_class = Class.new
app_class.include(DearFcc::App::CivicrmHelper)

describe DearFcc::App::CivicrmHelper do
  let(:filer){ { "email" => "user@example.com", "zip_code" => "12345" } }

  describe '#send_thank_you_email(filer)' do
    it "should delay a call to CivicrmWorker.send_thank_you_email" do
      delayed_worker = double("delayed_worker")

      expect(CivicrmWorker).to receive(:delay){ delayed_worker }
      expect(delayed_worker).to receive(:send_thank_you_email).
                                 with(filer["email"], { zip_code: filer["zip_code"], subscribe: false })

      app_class.new.send_thank_you_email(filer)
    end

    it "should not pass along invalid zip codes" do
      delayed_worker = double("delayed_worker")

      expect(CivicrmWorker).to receive(:delay){ delayed_worker }
      expect(delayed_worker).to receive(:send_thank_you_email).
                                 with(filer["email"], { zip_code: nil, subscribe: false })

      filer["zip_code"] = "1230442231123"

      app_class.new.send_thank_you_email(filer)
    end
  end
end

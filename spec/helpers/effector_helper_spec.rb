require "spec_helper"

app_class = Class.new
app_class.include(DearFcc::App::EffectorHelper)

describe DearFcc::App::EffectorHelper do
  let(:filer){ { "email" => "user@example.com", zip_code: "12345" } }

  describe '#sign_up_for_effector(filer)' do
    it "should delay a call to CivicrmWorker.subscribe" do
      delayed_worker = double("delayed_worker")

      expect(CivicrmWorker).to receive(:delay){ delayed_worker }
      expect(delayed_worker).to receive(:subscribe).with(filer["email"], filer["zip_code"])

      app_class.new.sign_up_for_effector(filer)
    end
  end
end
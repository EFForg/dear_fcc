require "spec_helper"

require "helpers/effector_helper"

app_class = Class.new
app_class.include(DearFcc::App::EffectorHelper)

describe DearFcc::App::EffectorHelper do
  let(:filer){ { "email" => "user@example.com", zip_code: "12345" } }

  describe '#sign_up_for_effector(filer)' do
    it "should delay a call to NewsletterWorker.signup" do
      delayed_worker = double("delayed_worker")

      expect(NewsletterWorker).to receive(:delay){ delayed_worker }
      expect(delayed_worker).to receive(:signup).with(filer["email"], filer["zip_code"])

      app_class.new.sign_up_for_effector(filer)
    end
  end
end

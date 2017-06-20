require "spec_helper"

require "workers/civicrm_worker"

describe CivicrmWorker do
  describe '.subscribe(email, zip_code)' do
    it "should call CivicrmClient#import_contact" do
      email, zip_code = "user@example.com", "94109"
      expect_any_instance_of(CivicrmClient).to receive(:import_contact).with(email: email, zip_code: zip_code)
      CivicrmWorker.subscribe(email, zip_code)
    end
  end
end

require "spec_helper"

describe CivicrmClient do
  api_key = ENV["CIVICRM_API_KEY"] = "test123"
  action_api = ENV["CIVICRM_API_PATH"] = "https://civicrm.example.com/action_api"

  let(:params) {
    {
      email: "user@example.com",
      first_name: "Ex",
      last_name: "Ample",
      source: "dearfcc.org",
      opt_in: false,
      city: "San Francisco",
      state: "CA",
      zip_code: "94109"
    }
  }

  let(:api_data) {
    {
      contact_params: params.slice(:email, :first_name, :last_name).merge(
        source: params[:source] || "dearfcc.org",
        subscribe: params[:subscribe],
        opt_in: params[:opt_in]
      ),
      address_params: params.slice(:city, :state).merge(
        street: params[:street_address],
        zip: params[:zip_code],
        country: params[:country_code]
      ),
      phone: params[:phone]
    }
  }

  describe '#import_contact' do
    it "should POST to $CIVICRM_API_PATH with { method: import_contact, data: ...params }" do
      payload = {
        site_key: api_key,
        method: "import_contact",
        data: api_data.to_json
      }

      contact_id = 123456

      stub_request(:post, action_api).with(body: payload).
        to_return(status: 200, body: { contact_id: contact_id }.to_json)

      expect(CivicrmClient.new.import_contact(params)).to eq(contact_id)
    end
  end

  describe '#subscribe' do
    it "should be like #import_contact but with subscribe: true" do
      payload = {
        site_key: api_key,
        method: "import_contact",
        data: api_data.tap{ |data| data[:contact_params][:subscribe] = true }.to_json
      }

      contact_id = 123456

      stub_request(:post, action_api).with(body: payload).
        to_return(status: 200, body: { contact_id: contact_id }.to_json)

      expect(CivicrmClient.new.subscribe(params)).to eq(contact_id)
    end
  end
end


class CivicrmClient
  class Error < Exception; end

  def import_contact(params)
    post(
      method: "import_contact",
      data: {
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
      }.to_json
    ).fetch("contact_id").to_i
  end

  def subscribe(params)
    import_contact params.merge(subscribe: true)
  end


  def send_email_template(contact_id:, template_id:, from:)
    post(
      method: "send_email_template",
      data: {
        message_template_id: template_id,
        contact_id: contact_id,
        from: from
      }.to_json
    )
    true
  end

  def add_activity(params)
    post(
      method: "add_activity",
      data: params.slice(:contact_id, :subject, :activity_type_id).to_json
    )
  end

  def find_contact_by_email(params)
    post(
      method: "find_contact_by_email",
      data: params.slice(:email).to_json
    )
  end

  private

  def post(params)
    supporters_api_url = ENV.fetch("CIVICRM_API_PATH")
    response = HTTParty.post(supporters_api_url, body: base_params.merge(params))
    raise Error.new unless (200...300).include?(response.code)

    response = JSON.parse(response.body)
    raise Error.new(response["error_message"]) if response["error"]

    response
  end

  def base_params
    { site_key: ENV.fetch("CIVICRM_API_KEY") }
  end
end

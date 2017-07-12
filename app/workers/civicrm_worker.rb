class CivicrmWorker
  def self.send_thank_you_email(email, zip_code: nil, subscribe: false)
    civicrm = CivicrmClient.new
    template_config = YAML.load("#{Padrino.env}/config/thank_you_email.yml")

    contact_params = { email: email }
    contact_params[:zip_code] = zip_code if zip_code
    contact_params[:subscribe] = true if subscribe

    contact_id = civicrm.import_contact(contact_params)

    civicrm.send_email_template(
      contact_id: contact_id,
      from: template_config.fetch("from"),
      template_id: template_config.fetch("template_id")
    )
  end

  def self.subscribe(email, zip_code=nil)
    CivicrmClient.new.import_contact(email: email, zip_code: zip_code, subscribe: true)
  end
end

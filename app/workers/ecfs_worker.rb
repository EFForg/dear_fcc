class EcfsWorker
  class Error < Exception; end

  def self.submit_comment(payload)
    api_key = ENV.fetch("ECFS_API_KEY")
    ecfs_uri = "https://publicapi.fcc.gov/ecfs/filings?api_key=#{api_key}"

    if Padrino.env == :production
      response = HTTParty.post(ecfs_uri, headers: { "Content-Type" => "application/json" }, body: payload.to_json)
      raise Error.new("HTTP #{response.code}") unless (200...300).include?(response.code)

      response = JSON.load(response.body)
    else
      response = { "confirm" => Time.now.strftime("%Y%m%d%H%M%S%L"),
                   "received" => Time.now.strftime("%FT%T%:z") }
    end

    Confirmation.create(fcc_confirm_id: response.fetch("confirm"),
                        fcc_received: response.fetch("received"))
  end

  def self.submit_comment_by_id(comment_id)
    comment = Comment.find(comment_id)
    submit_comment(comment.payload).tap do |confirmation|
      comment.update_column(:confirmation_id, confirmation.id)
    end
  end

  def self.csv_builder(io=StringIO.new)
    csv = CSV.new(io)
    csv << ["Proceeding Name", "Proceeding Description", "Proceeding ID",
            "Name of Filer", "Email Address", "Address Line 1", "Address Line 2",
            "City", "State", "Zip", "Zip Extension",
            "Date Received", "Comments"]
    csv
  end

  def self.csv_row(payload)
    proceeding = payload[:proceedings][0]
    name = payload[:filers][0].fetch(:name)
    email = payload.fetch(:contact_email)
    address = payload[:addressentity].fetch(:address_line_1)
    city = payload[:addressentity].fetch(:city)
    state = payload[:addressentity].fetch(:state)
    zip = payload[:addressentity].fetch(:zip_code)
    comment = payload.fetch(:text_data)

    [
      proceeding["name"], proceeding["description"], proceeding["id_proceeding"],
      name, email, address, nil,
      city, state, zip, nil,
      Time.now.strftime("%m/%d/%Y"), comment
    ]
  end
end

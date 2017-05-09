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

    response
  end
end

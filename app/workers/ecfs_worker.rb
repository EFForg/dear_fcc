class EcfsWorker
  class Error < Exception; end

  def self.submit_comment(payload)
    api_key = ENV.fetch("ECFS_API_KEY")
    ecfs_uri = "https://publicapi.fcc.gov/ecfs/filings?api_key=#{api_key}"

    if Padrino.env == :production
      response = HTTParty.post(ecfs_uri, headers: { "Content-Type" => "application/json" }, body: payload.to_json)
      raise Error.new("HTTP #{response.code}") unless (200...300).include?(response.code)
    end
  end
end

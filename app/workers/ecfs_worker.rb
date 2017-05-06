class EcfsWorker
  def self.submit_comment(payload)
    api_key = ENV.fetch("ECFS_API_KEY")
    ecfs_uri = "https://publicapi.fcc.gov/ecfs/filings?api_key=#{api_key}"

    if Padrino.env == :production
      HTTParty.post(ecfs_uri, headers: { "Content-Type" => "application/json" }, body: payload.to_json)
    end
  end
end

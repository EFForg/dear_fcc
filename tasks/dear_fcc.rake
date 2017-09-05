
require File.expand_path("./config/boot")

namespace :dear_fcc do
  desc "Dumps EcfsWorker jobs into CSV format and then clears them from queue"
  task :create_csv do
    io = StringIO.new
    csv = EcfsWorker.csv_builder(io)

    job_ids = []

    Delayed::Job.where(queue: "comments").find_each do |job|
      payload = YAML.load(job.handler).args[0]

      csv << EcfsWorker.csv_row(payload)
      job_ids << job.id

      break if io.size > 4.5.megabytes
    end

    io.rewind
    puts io.read

    Delayed::Job.where(id: job_ids).delete_all
  end

  desc "Clear the cache"
  task :cc do
    if ENV.key?("MEMCACHE_HOST") && Padrino.env == :production
      cache = Padrino::Cache.new(:Memcached,
                                 server: ENV.fetch("MEMCACHE_HOST"),
                                 exception_retry_limit: 1)
    else
      cache = Padrino::Cache.new(:File,
                                 dir: Padrino.root("tmp", "dear_fcc", "app", "cache"))
    end
    cache.clear
  end
end


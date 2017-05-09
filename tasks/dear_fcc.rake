
require File.expand_path("./config/boot")

namespace :dear_fcc do
  desc "Dump EcfsWorker jobs into CSV format. You should `rake jobs:clear` after submitting."
  task :create_csv do
    csv = EcfsWorker.csv_builder($stdout)

    Delayed::Job.where(queue: "comments").find_each do |job|
      payload = YAML.load(job.handler).args[0]

      csv << EcfsWorker.csv_row(payload)
    end
  end
end


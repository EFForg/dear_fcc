require 'sidekiq'
require 'sidekiq/api'

class NewsletterWorker
  include Sidekiq::Worker

  def perform(email, zip_code)
    supporters_uri = "https://supporters.eff.org/subscribe"
    params = {
      "data_type" => "json",
      "op" => "Subscribe",
      "email" => email,
      "postal_code" => zip_code,
      "form_id" => "eff_supporters_library_subscribe_form"
    }

    HTTParty.post(supporters_uri, body: params)
  end
end

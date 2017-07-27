module DearFcc
  class App
    module CivicrmHelper
      def send_thank_you_email(filer, subscribe: false)
        zip_code = filer["zip_code"].to_s =~ /^[0-9]{5}$/ ? filer["zip_code"] : nil

        CivicrmWorker.delay(queue: "civicrm").send_thank_you_email(
          filer.fetch("email"),
          zip_code: zip_code,
          subscribe: subscribe
        )
      end
    end

    helpers CivicrmHelper
  end
end

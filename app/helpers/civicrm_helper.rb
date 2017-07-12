module DearFcc
  class App
    module CivicrmHelper
      def send_thank_you_email(filer, subscribe: false)
        CivicrmWorker.delay(queue: "civicrm").send_thank_you_email(
          filer.fetch("email"),
          zip_code: filer["zip_code"],
          subscribe: subscribe
        )
      end
    end

    helpers CivicrmHelper
  end
end

module DearFcc
  class App
    module EffectorHelper
      def sign_up_for_effector(filer)
        CivicrmWorker.delay(queue: "signups").subscribe(filer.fetch("email"), filer["zip_code"])
      end
    end

    helpers EffectorHelper
  end
end

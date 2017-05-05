module DearFcc
  class App
    module EffectorHelper
      def sign_up_for_effector(filer)
        NewsletterWorker.delay.signup(filer.fetch("email"), filer.fetch("zip_code"))
      end
    end

    helpers EffectorHelper
  end
end

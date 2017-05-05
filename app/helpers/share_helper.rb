module DearFcc
  class App
    module ShareHelper
      def twitter_share_url
        twitter_params = {
          url: @share_url,
          text: @twitter_text,
          related: "eff"
        }

        "https://twitter.com/share?#{twitter_params.to_param}"
      end

      def facebook_share_url
        facebook_params = {
          u: @share_url,
          title: @facebook_text
        }

        "https://www.facebook.com/sharer/sharer.php?#{facebook_params.to_param}"
      end

      def google_share_url
        google_params = {
          url: @share_url
        }

        "https://plus.google.com/share?#{google_params.to_param}"
      end

      def email_share_url
        email_params = {
          subject: @email_subject,
          body: @email_text
        }

        "mailto:?#{email_params.to_param}"
      end
    end

    helpers ShareHelper
  end
end

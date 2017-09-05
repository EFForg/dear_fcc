module DearFcc
  class App
    module EcfsHelper
      def ecfs_express_comment(proceedings, comment, filer)
        payload = {
          documents: [],
          proceedings: [proceedings.first.slice("name", "id_proceeding", "description")],
          filers: [{ name: filer.fetch("name") }],
          authors: [],
          bureaus: [],
          lawfirms: [],
          addressentity: {},
          internationaladdressentity: { addresstext: "" },
          contact_email: filer.fetch("email"),
          text_data: comment,
          express_comment: 1
        }

        if filer.key?("international_address")
          payload.fetch(:internationaladdressentity)[:addresstext] = filer.fetch("international_address")
        else
          payload[:addressentity] = {
            address_line_1: filer.fetch("address_line_1"),
            city: filer.fetch("city"),
            state: filer.fetch("state"),
            zip_code: filer.fetch("zip_code")
          }
        end

        comment = Comment.create!(payload: payload)
        EcfsWorker.delay(queue: "comments").submit_comment_by_id(comment.id)
      end

      def ecfs_website_url
        # Proceeding name should be pulled from config/proceedings.yml but...
        "https://www.fcc.gov/ecfs/search/filings?proceedings_name=17-108&sort=date_disseminated,DESC"
      end
    end

    helpers EcfsHelper
  end
end

module DearFcc
  class App
    module EcfsHelper
      def ecfs_express_comment(proceeding, comment, filer)
        payload = {
          documents: [],
          proceedings: [proceeding],
          filers: [{ name: filer.fetch("name") }],
          authors: [],
          bureaus: [],
          lawfirms: [],
          addressentity: {
            address_line_1: filer.fetch("address_line_1"),
            city: filer.fetch("city"),
            state: filer.fetch("state"),
            zip_code: filer.fetch("zip_code")
          },
          internationaladdressentity: { addresstext: "" },
          contact_email: filer.fetch("email"),
          text_data: comment,
          express_comment: 1
        }

        EcfsWorker.delay.submit_comment(payload)
      end
    end

    helpers EcfsHelper
  end
end

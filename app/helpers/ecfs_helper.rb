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
#            zip4: filer.fetch("zip4")
          },
          internationaladdressentity: { addresstext: "" },
          contact_email: filer.fetch("email"),
          text_data: comment,
          express_comment: 1
        }

        pp filer

        pp payload
      end
    end

    helpers EcfsHelper
  end
end

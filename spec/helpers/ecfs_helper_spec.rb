require "spec_helper"

require "helpers/ecfs_helper"

app_class = Class.new
app_class.include(DearFcc::App::EcfsHelper)

describe DearFcc::App::EcfsHelper do
  let(:proceedings) {
    YAML.load_file("#{Padrino.root}/config/proceedings.yml")
  }

  let(:filer) {
    {
      "name" => "Test McTest",
      "address_line_1" => "123 Abc St.",
      "city" => "Testopolis",
      "state" => "CA",
      "zip_code" => "00001",
      "email" => "test@example.com"
    }
  }

  let(:international_filer) {
    filer.slice("name", "email").merge("international_address" => "123 Intl St.,\nElsewhere\nOverthere")
  }

  let(:comment) {
    "Don't do this or that."
  }

  let(:payload) {
    {
      documents: [],
      proceedings: proceedings,
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
  }

  let(:international_payload) {
    {
      documents: [],
      proceedings: proceedings,
      filers: [{ name: international_filer.fetch("name") }],
      authors: [],
      bureaus: [],
      lawfirms: [],
      addressentity: {},
      internationaladdressentity: { addresstext: international_filer.fetch("international_address") },
      contact_email: international_filer.fetch("email"),
      text_data: comment,
      express_comment: 1
    }
  }

  describe '#ecfs_express_comment' do
    it "should create a comment from params with an appropriately structured payload" do
      delayed_worker, comment_record = double, double(id: 123)

      expect(Comment).to receive(:create!).with(payload: payload){ comment_record }
      expect(EcfsWorker).to receive(:delay){ delayed_worker }
      expect(delayed_worker).to receive(:submit_comment_by_id).with(comment_record.id)

      app_class.new.ecfs_express_comment(proceedings, comment, filer)
    end

    context "filer has international_address" do
      it "should use internationaladdressentity instead of the usual fields" do
        delayed_worker, comment_record = double, double(id: 123)

        expect(Comment).to receive(:create!).with(payload: international_payload){ comment_record }
        expect(EcfsWorker).to receive(:delay){ delayed_worker }
        expect(delayed_worker).to receive(:submit_comment_by_id).with(comment_record.id)

        app_class.new.ecfs_express_comment(proceedings, comment, international_filer)
      end
    end
  end
end

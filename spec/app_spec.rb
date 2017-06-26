
require "rack/test"
require "spec_helper"

describe DearFcc::App do
  let(:app){ DearFcc::App }

  include Rack::Test::Methods

  authenticity_token_element = %(<input type="hidden" name="authenticity_token" )

  describe "GET /" do
    before { get "/" }

    it "should 200 OK" do
      expect(last_response.status).to eq(200)
    end

    it "should not Set-Cookie" do
      expect(last_response.headers.key?("Set-Cookie")).to be false
    end

    it "should not enable CSRF protection on its form" do
      expect(last_response.body[authenticity_token_element]).to be_nil
    end
  end

  describe "GET /thanks" do
    before { get "/thanks" }

    it "should 200 OK" do
      expect(last_response.status).to eq(200)
    end

    it "should not Set-Cookie" do
      expect(last_response.headers.key?("Set-Cookie")).to be false
    end
  end

  describe "POST /fcc-comments/confirm" do
    let(:comment_param) { }
    let(:filer_param) do
      {
        "name" => "Axe Bat",
        "address_line_1" => "123 Abc St.",
        "city" => "San Francisco",
        "state" => "CA",
        "zip_code" => "94109",
        "email" => "axe@example.com"
      }
    end

    before do
      allow(YAML).to receive(:load_file){ [] }
      post "/fcc-comments/confirm", comment: comment_param, filer: filer_param
    end

    it "should 200 OK" do
      expect(last_response.status).to eq(200)
    end

    pending "should Set-Cookie" do
      expect(last_response.headers.key?("Set-Cookie")).to be true
    end

    pending "should enable CSRF protection on its form" do
      expect(last_response.body[authenticity_token_element]).not_to be_nil
    end
  end

  describe "POST /fcc-comments" do
    let(:proceedings){ double("proceedings") }
    let(:comment_param){ "this is a message to the fcc ecfs filing system" }

    let(:filer_param) do
      {
        "name" => "Axe Bat",
        "address_line_1" => "123 Abc St.",
        "city" => "San Francisco",
        "state" => "CA",
        "zip_code" => "94109",
        "email" => "axe@example.com"
      }
    end

    def post_comment(params={})
      allow(YAML).to receive(:load_file){ proceedings }
      allow_any_instance_of(Padrino::AuthenticityToken).to receive(:except?){ true }
      post "/fcc-comments", params.merge(comment: comment_param, filer: filer_param)
    end

    it "should redirect to /thanks" do
      post_comment
      expect(last_response.status).to eq(302)
      expect(last_response.headers["Location"]).to eq("http://example.org/thanks")
    end

    it "should call the #ecfs_express_comment helper method" do
      expect_any_instance_of(app).to receive(:ecfs_express_comment).with(proceedings, comment_param, filer_param)
      post_comment
    end

    it "should call the #sign_up_for_effector helper method if subscribe=yes" do
      expect_any_instance_of(app).to receive(:sign_up_for_effector).with(filer_param)
      post_comment(subscribe: "yes")
    end

    it "should not call the #sign_up_for_effector helper method if subscribe != yes" do
      expect_any_instance_of(app).not_to receive(:sign_up_for_effector).with(filer_param)
      post_comment(subscribe: "no")
      post_comment
    end
  end
end

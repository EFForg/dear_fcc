module DearFcc
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    register Padrino::Cache
    enable :caching

    if ENV.key?("MEMCACHE_HOST") && Padrino.env == :production
      set :cache, Padrino::Cache.new(:Memcached,
                                     server: ENV.fetch("MEMCACHE_HOST"),
                                     exception_retry_limit: 1)
    end

    register Padrino::Sprockets
    sprockets

    set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 365]

    disable :protect_from_csrf
    disable :sessions

    layout  :dear_fcc             # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    set :logging, true            # Logging in STDOUT for development and file for production

    get "/", cache: Padrino.env == :production do
      render "index"
    end


    post "/fcc-comments/confirm" do
      @comment = read_dear_fcc_comment(params.fetch("comment"))
      @filer = params.fetch("filer")
      @subscribe = params["subscribe"] == "yes"
      render "confirm"
    end

    post "/fcc-comments" do
      unless params["test"].present?
        ecfs_express_comment(proceedings, params.fetch("comment"), params.fetch("filer"))
      end

      send_thank_you_email(params.fetch("filer"), subscribe: params["subscribe"] == "yes")

      redirect("/thanks")
    end

    get "/thanks", cache: true do
      render "thanks"
    end

    before do
      @share_url = "https://dearfcc.org/"
      @twitter_text = "Tell Congress to oppose FCC rules that allow ISP discrimination. " <<
                      "It's time to support real #NetNeutrality. Write now"
      @facebook_text = "Tell the FCC not to create new rules that threaten Net Neutrality.\n\n" <<
                       "It's our Internet.\n\n" <<
                       "We have to protect it.\n\n" <<
                       "https://DearFCC.org"

      @email_subject = "Tell the FCC not to create new rules that threaten Net Neutrality"
      @email_text = @facebook_text
    end

    before do
      request.session_options[:skip] = true unless request.post?
    end

    before except: "/" do
      unless comment_period_open?
        content_type "text/html"
        halt(404, render("404", layout: "dear_fcc_basic"))
      end
    end


    error ::Exception do
      response.status = 500
      content_type "text/html"
      render "500", layout: "dear_fcc_basic"
    end

    error Sinatra::NotFound do
      response.status = 404
      content_type "text/html"
      render "404", layout: "dear_fcc_basic"
    end
  end
end

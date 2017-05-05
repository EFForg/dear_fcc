module DearFcc
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    register Padrino::Sprockets
    sprockets

    disable :protect_from_csrf
    disable :sessions

    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    
    layout  :dear_fcc             # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    set :logging, true            # Logging in STDOUT for development and file for production

    get "/" do
      render "index"
    end

    post "/fcc-comments/confirm" do
      @comment = read_dear_fcc_comment(params.fetch("comment"))
      @filer = params.fetch("filer")
      @subscribe = params["subscribe"] == "yes"
      render "confirm"
    end

    post "/fcc-comments" do
      proceeding = YAML.load_file("#{Padrino.root}/config/proceeding.yml")
      ecfs_express_comment(proceeding, params.fetch("comment"), params.fetch("filer"))

      if params["subscribe"] == "yes"
        sign_up_for_effector(params.fetch("filer"))
      end

      redirect("/thanks")
    end

    get "/thanks" do
      render "thanks"
    end

    before do
      @share_url = "https://dearfcc.org/"
      @twitter_text = "Tell Congress to oppose FCC rules that allow ISP discrimination. " <<
                      "It's time to support real #NetNeutrality. Call now:"
      @facebook_text = "Tell the FCC not to create new rules that threaten Net Neutrality.\n\n" <<
                       "It's our Internet.\n\n" <<
                       "We have to protect it.\n\n" <<
                       "https://DearFCC.org"

      @email_subject = "Tell the FCC not to create new rules that threaten Net Neutrality"
      @email_text = @facebook_text
    end

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 500 do
    #     render 'errors/500'
    #   end
    #
  end
end

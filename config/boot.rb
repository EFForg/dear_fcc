# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

require "active_support"
require "active_support/core_ext"

require "dotenv/load"

require "rack/attack"

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure Ruby to allow requiring features from your lib folder
#
$LOAD_PATH.unshift Padrino.root('lib')

#
# ## Enable logging of source location
#
# Padrino::Logger::Config[:development][:source_location] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
# I18n.enforce_available_locales = false
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Require initializers before all other dependencies.
# Dependencies from 'config' folder are NOT re-required on reload.
#
Padrino.dependency_paths.unshift Padrino.root('config/initializers/*.rb')

##
# Add your before (RE)load hooks here
# These hooks are run before any dependencies are required.
#
Padrino.before_load do
  Padrino.dependency_paths << Padrino.root("app/workers/*.rb")
  Padrino.dependency_paths << Padrino.root("app/helpers/*.rb")
  Padrino.dependency_paths << Padrino.root("lib/*.rb")
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
  if Padrino.env == :test
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: ':memory:'
    )
    load("#{Padrino.root}/db/schema.rb")
  else
    dbconfig = {
      adapter: 'postgresql',
      encoding: 'utf8',
      reconnect: true,
      pool: 5,
      database: ENV.fetch('POSTGRES_DB'),
      username: ENV.fetch('POSTGRES_USER'),
      password: ENV.fetch('POSTGRES_PASSWORD'){ '' },
      host: ENV.fetch('POSTGRES_HOST')
    }

    ActiveRecord::Base.configurations[:development] = dbconfig
    ActiveRecord::Base.configurations[:production] = dbconfig
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])
  end
end



if ENV.key?("MEMCACHE_HOST")
  Rack::Attack.cache.store = ActiveSupport::Cache::MemCacheStore.new(ENV.fetch("MEMCACHE_HOST"))

  Rack::Attack.throttle('comments_req/ip', limit: 15, period: 1.hour) do |req|
    req.env["HTTP_X_FORWARDED_FOR"] if req.path == "/fcc-comments"
  end

  Rack::Attack.throttle('comments_confirm_req/ip', limit: 15, period: 1.hour) do |req|
    req.env["HTTP_X_FORWARDED_FOR"] if req.path == "/fcc-comments/confirm"
  end
end


Padrino.load!

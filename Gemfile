source 'https://rubygems.org'

# Padrino supports Ruby version 1.9 and later
# ruby '2.3.1'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Padrino Stable Gem
gem 'padrino', '~> 0.13'

# Project requirements
gem 'rake'
gem 'pg'
gem 'activerecord', require: 'active_record'
gem 'delayed_job_active_record'
gem 'httparty'
gem 'dotenv'
gem 'rack-attack'
gem 'dalli'
gem 'sentry-raven'

# Assets
gem 'padrino-sprockets'
gem 'sass'

# Test/development requirements
group :test do
  gem 'rspec'
  gem 'webmock'
end

group :test, :development do
  gem 'pry'
end

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.13.3.3'
# end

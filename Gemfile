source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "puma", "~> 5.0"

# Core
gem 'apipie-rails'
gem 'awesome_print'
gem "bootsnap", require: false
gem 'canonical-rails', github: 'jumph4x/canonical-rails'
gem 'config'
gem 'deep_cloneable', '~> 3.2.0'
gem 'uploadcare-rails'
gem 'friendly_id'
gem 'httparty'
gem 'maruku'
gem 'reverse_markdown'
gem 'invisible_captcha'
gem 'jsonb_accessor'
gem "jbuilder"
gem 'rack-canonical-host'
gem 'simple_scheduler'
gem 'sitemap_generator'
gem 'slack-notifier'
gem 'ruby-openai'
gem 'rexml'

# Database
gem 'hiredis'
gem "pg", "~> 1.1"
gem 'redis'
gem 'sidekiq'

# Authentication
gem 'devise'
gem 'devise-tailwindcssed', github: 'realstorypro/devise-tailwindcssed-ruby', branch: 'ruby-3.2-support'

# Pagination
gem 'kaminari', github: 'kaminari/kaminari', branch: 'master'

# Frontend
gem 'meta-tags'
gem 'rapid_ui', github: 'realstorypro/rapid-ui'
gem 'simple_form'
gem 'slim-rails'
gem 'sprockets-rails'
gem "stimulus-rails"
gem 'turbo-rails'
gem 'view_component'
gem 'vite_rails'
gem 'redcarpet'

# Errors
gem 'appsignal'

# Middleware
gem 'rack-attack'
gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'tty-prompt'
  gem 'webmock'
end

group :development do
  gem "web-console"
  gem 'annotate'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rspec_tap', require: false
  gem 'timecop'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webdrivers'
end


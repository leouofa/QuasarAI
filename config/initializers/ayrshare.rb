require 'ayrshare'

Ayrshare.configure do |config|
  config.api_key = ENV['AYRSHARE_API_KEY']
end
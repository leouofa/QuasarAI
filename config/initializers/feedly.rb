require 'feedly'

Feedly.configure do |config|
  config.token = ENV['FEEDLY_TOKEN']
end

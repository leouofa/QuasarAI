require 'story_pro'

StoryPro.configure do |config|
  config.url = ENV['STORYPRO_API_URL']
  config.api_key = ENV['STORYPRO_API_KEY']
end

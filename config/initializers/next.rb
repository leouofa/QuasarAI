require 'next_leg'

NextLeg.configure do |config|
  config.token = ENV['NEXT_LEG_TOKEN']
end
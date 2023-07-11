require 'httparty'
require 'json'

module Ayrshare
  class Configuration
    attr_accessor :api_key

    def initialize
      @api_key = nil
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.post_message(post:, platforms:, auto_hashtag:, media_urls: [])
    url = "https://app.ayrshare.com/api/post"
    headers = { 'Authorization' => "Bearer #{configuration.api_key}" }
    body = { post:, platforms:, mediaUrls: [media_urls], autoHashtag: auto_hashtag }

    response = HTTParty.post(url, headers:, body:)

    raise "Error: #{response.code} - #{response.body}" unless response.code == 200

    JSON.parse(response.body)
  end
end

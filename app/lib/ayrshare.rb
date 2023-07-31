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

  def self.post_plain_message(post:, platforms:)
    url = "https://app.ayrshare.com/api/post"
    headers = { 'Authorization' => "Bearer #{configuration.api_key}" }
    body = { post:, platforms: }

    response = HTTParty.post(url, headers:, body:)

    raise "Error: #{response.code} - #{response.body}" unless response.code == 200

    JSON.parse(response.body)
  end

  def self.post_pinterest_message(post:, platforms: ['pinterest'], media_urls: [], pinterest_options: {})
    url = "https://app.ayrshare.com/api/post"
    headers = { 'Authorization' => "Bearer #{configuration.api_key}" }
    body = { post:, platforms:, mediaUrls: [media_urls], pinterestOptions: pinterest_options }

    response = HTTParty.post(url, headers:, body:)

    raise "Error: #{response.code} - #{response.body}" unless response.code == 200

    JSON.parse(response.body)
  end

  def self.post_carousel(post:, facebook_options: {})
    url = "https://app.ayrshare.com/api/post"
    headers = { 'Authorization' => "Bearer #{configuration.api_key}" }
    body = { post:, platforms: ['facebook'], faceBookOptions: facebook_options }

    response = HTTParty.post(url, headers:, body:)

    raise "Error: #{response.code} - #{response.body}" unless response.code == 200

    JSON.parse(response.body)
  end

  def self.post_message(post:, platforms:, media_urls: [])
    url = "https://app.ayrshare.com/api/post"
    headers = { 'Authorization' => "Bearer #{configuration.api_key}" }
    body = { post:, platforms:, mediaUrls: [media_urls] }

    response = HTTParty.post(url, headers:, body:)

    raise "Error: #{response.code} - #{response.body}" unless response.code == 200

    JSON.parse(response.body)
  end
end

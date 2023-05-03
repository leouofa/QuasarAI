require 'net/http'
require 'json'

module Feedly
  class Configuration
    attr_accessor :token

    def initialize
      @token = nil
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.get_contents(stream_id)
    url = "https://cloud.feedly.com/v3/streams/contents?streamId=#{stream_id}"
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{configuration.token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    raise "Error: #{response.code} - #{response.body}" unless response.code == '200'

    JSON.parse(response.body)
  end
end

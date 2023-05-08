require 'net/http'
require 'json'

module NextLeg
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

  def self.send_request(endpoint, payload)
    url = "https://api.thenextleg.io/v2/#{endpoint}"

    headers = {
      'Authorization' => "Bearer #{configuration.token}",
      'Content-Type' => 'application/json'
    }

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = payload.to_json

    response = http.request(request)

    raise "Error: #{response.code} - #{response.body}" unless response.code == '200'

    JSON.parse(response.body)
  end

  def self.imagine(prompt:, ref: "")
    payload = {
      "msg" => prompt,
      "ref" => ref,
      "webhookOverride" => ""
    }

    send_request("imagine", payload)
  end

  def self.slash_command(cmd:, ref: "")
    valid_commands = %w[relax fast private stealth]
    raise "Invalid command. Valid commands are: #{valid_commands.join(', ')}" unless valid_commands.include?(cmd)

    payload = {
      "cmd" => cmd,
      "ref" => ref,
      "webhookOverride" => ""
    }

    send_request("slash-commands", payload)
  end

  def self.press_button(button:, ref: "", button_message_id: "")
    payload = {
      "button" => button,
      "ref" => ref,
      "webhookOverride" => "",
      "buttonMessageId" => button_message_id
    }


    send_request("button", payload)
  end
end

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

  def self.send_request(endpoint, payload, method: :post, version: :v2)
    url = if version == :v2
            "https://api.thenextleg.io/v2/#{endpoint}"
          else
            "https://api.thenextleg.io/#{endpoint}"
          end

    headers = {
      'Authorization' => "Bearer #{configuration.token}",
      'Content-Type' => 'application/json'
    }

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    if method == :post
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = payload.to_json
    elsif method == :get
      uri.query = URI.encode_www_form(payload)
      request = Net::HTTP::Get.new(uri.request_uri, headers)
    end

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

  def self.upscale(button:, button_message_id: "")
    payload = {
      button:,
      buttonMessageId: button_message_id
    }
    send_request("upscale-img-url", payload, method: :get, version: :v1)
  end
end

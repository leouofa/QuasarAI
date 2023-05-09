require 'net/http'
require 'json'

module StoryPro
  class Configuration
    attr_accessor :url, :api_key

    def initialize
      @url = nil
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

  def self.send_request(method, endpoint, payload: nil, query_params: {})
    url = "#{configuration.url}/#{endpoint}"
    url += "?#{URI.encode_www_form(query_params)}" unless query_params.empty?

    headers = {
      'X-API-Key' => configuration.api_key,
      'Content-Type' => 'application/json'
    }

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = case method
              when :post
                req = Net::HTTP::Post.new(uri.request_uri, headers)
                req.body = payload.to_json
                req
              when :get
                Net::HTTP::Get.new(uri.request_uri, headers)
              end

    response = http.request(request)

    raise "Error: #{response.code} - #{response.body}" unless response.code == '200'

    JSON.parse(response.body)
  end

  def self.send_post_request(endpoint, payload)
    send_request(:post, endpoint, payload: payload)
  end

  def self.send_get_request(endpoint, query_params = {})
    send_request(:get, endpoint, query_params: query_params)
  end

  def self.get_entries(kind: nil, status: nil)
    allowed_kinds = %w[article video discussion promotion]
    allowed_statuses = %w[published unpublished scheduled]

    if kind && !allowed_kinds.include?(kind)
      raise ArgumentError, "Invalid kind: '#{kind}'. Allowed values are: #{allowed_kinds.join(', ')}"
    end

    if status && !allowed_statuses.include?(status)
      raise ArgumentError, "Invalid status: '#{status}'. Allowed values are: #{allowed_statuses.join(', ')}"
    end

    query_params = {}
    query_params['kind'] = kind if kind
    query_params['status'] = status if status

    send_get_request('entries', query_params)
  end

  def self.create_entry(type, name: nil, user_id: nil, category_id: nil, url: nil)
    allowed_types = %w[article video discussion promotion]

    unless allowed_types.include?(type)
      raise ArgumentError, "Invalid type: '#{type}'. Allowed values are: #{allowed_types.join(', ')}"
    end

    raise ArgumentError, "name is required" unless name
    raise ArgumentError, "user_id is required" unless user_id

    payload = {
      type => {
        'name' => name,
        'user_id' => user_id,
        'category_id' => category_id,
        'url' => url
      }
    }

    send_post_request(pluralize(type), payload)
  end

  def self.pluralize(word)
    word.end_with?('s') ? word : "#{word}s"
  end

  def self.create_discussion(name: nil, user_id: nil, category_id: nil)
    create_entry('discussion', name: name, user_id: user_id, category_id: category_id)
  end

  def self.create_article(name: nil, user_id: nil, category_id: nil)
    create_entry('article', name: name, user_id: user_id, category_id: category_id)
  end

  def self.create_video(name: nil, user_id: nil, category_id: nil)
    create_entry('video', name: name, user_id: user_id, category_id: category_id)
  end

  def self.create_promotion(name: nil, user_id: nil, category_id: nil, url: nil)
    create_entry('promotion', name: name, user_id: user_id, category_id: category_id, url: url)
  end

  def self.create_tag(name:, promotion_only: false)
    raise ArgumentError, "name is required" unless name

    payload = {
      'tag' => {
        'name' => name,
        'promotion_only' => promotion_only.to_s
      }
    }

    send_post_request('tags', payload)
  end

  def self.create_category(name:, color_id:)
    raise ArgumentError, "name is required" unless name
    raise ArgumentError, "color_id is required" unless color_id

    payload = {
      'category' => {
        'name' => name,
        'color_id' => color_id
      }
    }

    send_post_request('categories', payload)
  end
end


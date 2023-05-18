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
              when :put
                req = Net::HTTP::Put.new(uri.request_uri, headers)
                req.body = payload.to_json
                req
              when :delete
                Net::HTTP::Delete.new(uri.request_uri, headers)
              end

    response = http.request(request)

    raise "Error: #{response.code} - #{response.body}" unless response.code == '200'

    JSON.parse(response.body)
  end

  def self.send_post_request(endpoint, payload)
    send_request(:post, endpoint, payload:)
  end

  def self.send_get_request(endpoint, query_params = {})
    send_request(:get, endpoint, query_params:)
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

  def self.get_users(role: nil)
    allowed_roles = %w[admin editor member banned]

    if role && !allowed_roles.include?(role)
      raise ArgumentError, "Invalid role: '#{role}'. Allowed values are: #{allowed_roles.join(', ')}"
    end

    query_params = {}
    query_params['role'] = role if role

    send_get_request('users', query_params)
  end

  def self.get_colors
    send_get_request('colors')
  end

  def self.get_discussion_fields
    send_get_request('discussions/new')
  end

  def self.create_discussion(name: nil, user_id: nil, category_id: nil)
    create_entry('discussion', name:, user_id:, category_id:)
  end

  def self.get_discussion(id)
    raise ArgumentError, "id is required" unless id

    send_get_request("discussions/#{id}")
  end

  def self.update_discussion(id, **options)
    raise ArgumentError, "id is required" unless id

    payload = { 'discussion' => {} }
    options.each do |key, value|
      if key.to_s == 'tags'
        payload[key.to_s] = value
      else
        payload['discussion'][key.to_s] = value
      end
    end

    send_request(:put, "discussions/#{id}", payload: payload)
  end

  def self.delete_discussion(id)
    raise ArgumentError, "id is required" unless id

    send_request(:delete, "discussions/#{id}")
  end

  def self.get_article_fields
    send_get_request('articles/new')
  end

  def self.create_article(name: nil, user_id: nil, category_id: nil)
    create_entry('article', name:, user_id:, category_id:)
  end

  def self.get_article(id)
    raise ArgumentError, "id is required" unless id

    send_get_request("articles/#{id}")
  end

  def self.update_article(id, **options)
    raise ArgumentError, "id is required" unless id

    payload = { 'article' => {} }
    options.each do |key, value|
      if key.to_s == 'tags'
        payload[key.to_s] = value
      else
        payload['article'][key.to_s] = value
      end
    end

    send_request(:put, "articles/#{id}", payload: payload)
  end

  def self.delete_article(id)
    raise ArgumentError, "id is required" unless id

    send_request(:delete, "articles/#{id}")
  end

  def self.get_video_fields
    send_get_request('videos/new')
  end

  def self.create_video(name: nil, user_id: nil, category_id: nil)
    create_entry('video', name:, user_id:, category_id:)
  end

  def self.get_video(id)
    raise ArgumentError, "id is required" unless id

    send_get_request("videos/#{id}")
  end

  def self.update_video(id, **options)
    raise ArgumentError, "id is required" unless id

    payload = { 'video' => {} }
    options.each do |key, value|
      if key.to_s == 'tags'
        payload[key.to_s] = value
      else
        payload['video'][key.to_s] = value
      end
    end

    send_request(:put, "videos/#{id}", payload: payload)
  end

  def self.delete_video(id)
    raise ArgumentError, "id is required" unless id

    send_request(:delete, "videos/#{id}")
  end

  def self.get_promotion_fields
    send_get_request('promotions/new')
  end

  def self.create_promotion(name: nil, user_id: nil, category_id: nil, url: nil)
    create_entry('promotion', name:, user_id:, category_id:, url:)
  end

  def self.get_promotion(id)
    raise ArgumentError, "id is required" unless id

    send_get_request("promotions/#{id}")
  end

  def self.update_promotion(id, **options)
    raise ArgumentError, "id is required" unless id

    payload = { 'promotion' => {} }
    options.each do |key, value|
      if key.to_s == 'tags'
        payload[key.to_s] = value
      else
        payload['promotion'][key.to_s] = value
      end
    end

    send_request(:put, "promotions/#{id}", payload: payload)
  end

  def self.delete_promotion(id)
    raise ArgumentError, "id is required" unless id

    send_request(:delete, "promotions/#{id}")
  end

  def self.get_tags
    send_get_request('tags')
  end

  def self.get_tag_fields
    send_get_request('tags/new')
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

  def self.get_tag(id)
    raise ArgumentError, "id is required" unless id

    send_get_request("tags/#{id}")
  end

  def self.update_tag(id, name:, promotion_only: nil)
    raise ArgumentError, "id is required" unless id
    raise ArgumentError, "name is required" unless name

    payload = {
      'tag' => {
        'name' => name
      }
    }
    payload['tag']['promotion_only'] = promotion_only.to_s unless promotion_only.nil?

    send_request(:put, "tags/#{id}", payload:)
  end

  def self.delete_tag(id)
    raise ArgumentError, "id is required" unless id

    send_request(:delete, "tags/#{id}")
  end

  def self.get_categories
    send_get_request('categories')
  end

  def self.get_category_fields
    send_get_request('categories/new')
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

  def self.get_category(id)
    raise ArgumentError, "id is required" unless id

    send_get_request("categories/#{id}")
  end

  def self.update_category(id, name: nil, color_id: nil)
    raise ArgumentError, "id is required" unless id
    raise ArgumentError, "Either name or color_id must be provided" if name.nil? && color_id.nil?

    payload = {}
    payload['name'] = name if name
    payload['color_id'] = color_id if color_id

    send_request(:put, "categories/#{id}", payload:)
  end

  def self.delete_category(id)
    raise ArgumentError, "id is required" unless id

    send_request(:delete, "categories/#{id}")
  end

  def self.get_elements(type: nil)
    query_params = {}
    query_params['type'] = type if type

    send_get_request('elements', query_params)
  end

  def self.add_element(element:, parent_id:, parent_component:, area:)
    valid_areas = {
      'articles' => %w[header content reference],
      'videos' => %w[header content reference],
      'discussions' => %w[header content reference],
      'promotions' => %w[header content reference],
      'site_settings_theme_homepage' => ['homepage'],
      'site_settings_theme_css' => %w[page fullscreen regular featured]
    }

    if valid_areas[parent_component].nil?
      raise ArgumentError, "Invalid parent_component: '#{parent_component}'"
    elsif !valid_areas[parent_component].include?(area)
      raise ArgumentError,
            "Invalid area: '#{area}' for parent_component '#{parent_component}'. Allowed values are: #{valid_areas[parent_component].join(', ')}"
    end

    payload = {
      'element' => element,
      'parent_id' => parent_id,
      'parent_component' => parent_component,
      'area' => area
    }

    send_post_request("elements/add", payload)
  end

  def self.update_element(id, element:, **options)
    raise ArgumentError, "id is required" unless id
    raise ArgumentError, "element is required" unless element

    payload = { element => {} }
    options.each do |key, value|
      payload[element][key.to_s] = value
    end

    send_request(:put, "elements/#{id}", payload:)
  end

  def self.delete_element(id)
    raise ArgumentError, "id is required" unless id

    send_request(:delete, "elements/#{id}")
  end

  def self.get_distinct_elements
    send_get_request('elements/distinct')
  end

  def self.get_settings
    send_get_request('settings')
  end

  def self.pluralize(word)
    word.end_with?('s') ? word : "#{word}s"
  end
end

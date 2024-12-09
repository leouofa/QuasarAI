# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name = "#{ENV['ORGANIZATION']} API"
  config.app_info['1.0'] = "#{ENV['ORGANIZATION']} API documentation"
  config.api_base_url['1.0'] = '/api/v1'
  config.doc_base_url = '/apipie'
  config.copyright = "&copy; 2023 #{ENV['ORGANIZATION']}]}"
  config.markup = Apipie::Markup::Markdown.new
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"

  # Updated deprecation warnings fixes
  config.generator.swagger.content_type_input = :json
  config.generator.swagger.json_input_uses_refs = false
  config.generator.swagger.security_definitions = { ApiKeyAuth: { type: 'apiKey', in: 'header', name: 'X-API-Key' } }
  config.generator.swagger.global_security = [{ ApiKeyAuth: [] }]

  config.authenticate = proc do
    authenticate_or_request_with_http_basic do |username, password|
      username == 'api' && password == ENV['API_KEY']
    end
  end
end

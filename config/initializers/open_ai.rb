OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.uri_base = ENV.fetch("OPENAI_URL_BASE")
  config.request_timeout = 240 # Optional
end

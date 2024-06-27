class Pillars::CreatePillarColumnTopicsJob < ApplicationJob
  queue_as :default
  include SettingsHelper

  def perform(pillar_column:)
    pillar = pillar_column.pillar
    pillar_settings = s('pillars')
    found_setting = pillar_settings.find { |pillar_setting| pillar_setting.name == pillar.title }

    return if found_setting.nil?

    @client = OpenAI::Client.new

    system_role = <<~SYSTEM_ROLE
        You are a senior content writer, experienced in SEO, working for a digital agency. 
        DONT MAKE ANYTHING UP.
    SYSTEM_ROLE

    question = <<~QUESTION
        - You have received a request to create #{found_setting.articles} topics relating to `#{pillar_column.name}` and `#{pillar_column.description}`
        - The topic should have a `title` that is 65 characters long will summarizes the the topic.
        - The topic should have a `summary` that is 120 characters long will summarizes the topic.
        - The return result MUST only return JSON in the following structure:

        ```
         content: [
            {
              "title": "article title",
              "summary": "article summary"
            },
            {
              "title": "article title",
              "summary": "article summary"
            }
         ]
        ```
    QUESTION

    messages = [
      { role: "system", content: system_role },
      { role: "user", content: question }
    ]

    invalid_json = true
    counter = 0
    response = nil

    while invalid_json && counter < 4
      response = chat(messages:)

      counter += 1

      break if response["error"].present?

      extracted_json_response = extract_json_from_string(response["choices"][0]["message"]["content"])

      invalid_json = false if valid_json?(extracted_json_response)
      Rails.logger.debug "invalid_json: #{invalid_json} | counter: #{counter}"
    end

    unless response["error"].present?
      parsed_response = JSON.parse(extracted_json_response)

      pillar_column.update(topics: parsed_response["content"])

      sleep(20)
    end
  end

  def valid_json?(json_string)
    JSON.parse(json_string)
    true
  rescue JSON::ParserError
    false
  end

  def extract_json_from_string(input_string)
    json_start = input_string.index("{")
    json_end = input_string.rindex("}")

    if json_start && json_end
      json_str = input_string[json_start..json_end+1]
    else
      input_string
    end
  end

  def chat(messages:)
    @client.chat(
      parameters: {
        model: ENV['OPENAI_GPT_MODEL'], # Required.
        messages:,
        temperature: 0.7
      }
    )
  end
end

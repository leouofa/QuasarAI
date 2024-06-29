class Articles::CreateArticlesJob < ApplicationJob
  queue_as :default
  include SettingsHelper

  def perform(pillar_topic:)
    pillar_column = pillar_topic.pillar_column
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
        - You have received a request to create an article about `#{pillar_topic.title}` and `#{pillar_topic.summary}`
        - It is your job to write an article consisting of 6 sections, each section has the following format:
        ```
        + header
        -- paragraph1
        -- paragraph2
        -- paragraph3
        ```

        - The `header` should be no more than 80 characters long and summarizes the section.
        - The `paragraphs` should be 4-5 sentences that support the `header`.

        - The article should have a `title` that is 65 characters long and summarizes the entire article.
        - The article should have a `summary` that is 120 characters long and summarizes the entire article.
        - The return result MUST be in JSON format in the following structure:

        ```
         title: "article title",
         summary: "article summary",
         content: [
            {
              "header": "header text",
              "paragraphs": ["paragraph1 text", "paragraph2 text", "paragraph3 text"]
            },
            {
              "header": "header text",
              "paragraphs": ["paragraph1 text", "paragraph2 text", "paragraph3 text"]
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

      invalid_json = false if valid_json?(response["choices"][0]["message"]["content"])
      Rails.logger.debug "invalid_json: #{invalid_json} | counter: #{counter}"

      sleep(10)
    end

    unless response["error"].present? || invalid_json
      parsed_response = JSON.parse(response["choices"][0]["message"]["content"])

      Article.create(pillar_column:,
                     name: parsed_response["title"],
                     description: parsed_response["summary"],
                     original_text: parsed_response["content"])

      pillar_topic.update(processed: true)
    end

    pillar_topic.update(processed: true)
    sleep(10)
  end

  def valid_json?(json_string)
    JSON.parse(json_string)
    true
  rescue JSON::ParserError
    false
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

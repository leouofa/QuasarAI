class Discussions::MakeStemJob < ApplicationJob
  queue_as :default
  include SettingsHelper

  def perform(story:)
    return if story.discussion.present?

    @client = OpenAI::Client.new

    prompts = story.sub_topic.prompts
    prompt_keywords =  s("prompts.#{prompts}.discussions.stem.keywords")

    keywords = if prompt_keywords.length > 0
      <<~KEYWORDS
        - if possible have an article contain the following keywords: #{prompt_keywords}
      KEYWORDS
    else
      nil
    end

    system_role = <<~SYSTEM_ROLE
        #{s("prompts.#{prompts}.discussions.stem.system_role")}
    SYSTEM_ROLE

    brief = <<~BRIEF
        You have received the following story in JSON format:

        #{story.stem}
    BRIEF

    question = <<~QUESTION
        - You have received the following as a news brief about `#{story.sub_topic.name}` and `#{story.tag.name}`.
        - It is your job to write an article consisting of 6 sections, each section has the following format:
        ```
        + header
        -- paragraph1
        -- paragraph2
        -- paragraph3
        ```

        - The `header` should be no more then 80 characters long sentence and summarizes the section.
        - The `paragraphs` should be 4-5 sentences that support the `header`.

        - The article should have a `title` that is 65 character long and summarizes the entire article.
        - The article should have a `summary` that is 120 character long and summarizes the entire article.
        #{keywords if keywords}
        - The return result MUST be in JSON format in the following structure:

        ```
         title: "article title",
         summary: "article summary",
         content: [
            {
              "header": "header text",
              "paragraphs": ["paragraph1 text", "paragraph2 text", paragraph3 text"]
            },
            {
              "header": "header text",
              "paragraphs": ["paragraph1 text", "paragraph2 text", paragraph3 text"]
            }
         ]
        ```
    QUESTION

    messages = [
      { role: "system", content: system_role },
      { role: "user", content: brief },
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
    end

    if response["error"].present?
      Discussion.create(story:, processed: true, invalid_json:)
    else
      Discussion.create(story:, stem: response["choices"][0]["message"]["content"], processed: true, invalid_json:)
    end
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

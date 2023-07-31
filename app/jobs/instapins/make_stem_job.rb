class Instapins::MakeStemJob < ApplicationJob
  queue_as :default
  include SettingsHelper

  def perform(discussion:)
    return if discussion.instapin.present?

    @client = OpenAI::Client.new

    prompts = discussion.story.sub_topic.prompts
    story = discussion.story

    system_role = <<~SYSTEM_ROLE
        #{s("prompts.#{prompts}.tweets.stem.system_role")}
    SYSTEM_ROLE

    brief = <<~BRIEF
        You have received the following story in JSON format:

        #{discussion.stem}
    BRIEF

    question = <<~QUESTION
        - You have received the following as a news story about `#{story.sub_topic.name}` and `#{story.tag.name}`.
        - It is your job to write #{s("prompts.#{prompts}.tweets.stem.tone")} 400 character `post` about this story.
        - You must include relevant 2 to 3 `hashtags` and  2 to 3 `emojis` into the `post`.
        - The return result MUST be in JSON format in the following structure:

        ```
        {
         post: "this is a post",
        }
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

    while invalid_json && counter < 6
      response = chat(messages:)

      counter += 1

      break if response["error"].present?

      invalid_json = false if valid_json?(response["choices"][0]["message"]["content"])
      Rails.logger.debug "invalid_json: #{invalid_json} | counter: #{counter}"
    end

    if response["error"].present?
      Instapin.create(discussion:, processed: true, invalid_json:)
    else
      Instapin.create(discussion:, stem: response["choices"][0]["message"]["content"], processed: true, invalid_json:)
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

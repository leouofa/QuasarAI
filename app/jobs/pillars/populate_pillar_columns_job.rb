class Pillars::PopulatePillarColumnsJob < ApplicationJob
  queue_as :default

  def perform(pillar:)
    @client = OpenAI::Client.new

    system_role = <<~SYSTEM_ROLE
      You are an NLP researcher.
    SYSTEM_ROLE

    question = <<~QUESTION
      - Produce a list of top #{pillar.columns} topics relating to the word #{pillar.title}.
      - The return result MUST be in JSON format in the following structure:
      ```
        topics: [
          "title": "topic title",
          "description": "topic description"
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

      if valid_json?(response["choices"][0]["message"]["content"])
        invalid_json = false
        populate_pillar_columns(pillar, response["choices"][0]["message"]["content"])
      end

      Rails.logger.debug "invalid_json: #{invalid_json} | counter: #{counter}"
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

  def populate_pillar_columns(pillar, json_content)
    topics = JSON.parse(json_content)["topics"]
    topics.each do |topic|
      next unless PillarColumn.where(pillar_id: pillar.id).count < pillar.columns && !PillarColumn.exists?(pillar_id: pillar.id,
                                                                                                           name: topic["title"])

      PillarColumn.create!(
        pillar_id: pillar.id,
        name: topic["title"],
        description: topic["description"]
      )
    end
  end
end

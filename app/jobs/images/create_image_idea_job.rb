module Images
  class CreateImageIdeaJob < ApplicationJob
    queue_as :default
    include SettingsHelper

    def perform(story:)
      return if story.invalid_images
      return if story.images.count.positive?

      @client = OpenAI::Client.new

      prompts = story.sub_topic.prompts

      system_role = <<~SYSTEM_ROLE
        #{s("prompts.#{prompts}.image_idea.system_role")}
      SYSTEM_ROLE

      brief = <<~BRIEF
        You have received the following story in JSON format:

        #{story.stem}
      BRIEF

      question = <<~QUESTION
        - The story is about `#{story.sub_topic.name}` and `#{story.tag.name}`.
        - It is your job to come up with 3 ai image ideas that support the story.
        - The each image idea should be 4-5 sentences that support the story.
        - #{s("prompts.#{prompts}.image_idea.style")}

         Return the answer as a JSON object with the following structure:

        ```
        { "images": [
          { "description": "image idea 1" },
          { "description": "image idea 2" },
          { "description": "image idea 3" } ]
        }
        ```
      QUESTION

      messages = [
        { role: "system", content: system_role },
        { role: "user", content: brief },
        { role: "user", content: question }
      ]

      invalid_images = true
      counter = 0
      response = nil

      while invalid_images && counter < 4
        response = chat(messages:)

        counter += 1

        break if response["error"].present?

        invalid_images = false if valid_json?(response["choices"][0]["message"]["content"])
        Rails.logger.debug "invalid_json: #{invalid_images} | counter: #{counter}"
      end

      if response["error"].present? || invalid_images
        story.update(invalid_images: true)
      else
        image_ideas = JSON.parse(response["choices"][0]["message"]["content"])["images"]

        image_ideas.each do |idea|
          Image.create(story:, idea: idea["description"])
        end
      end

      Rails.logger.debug "Images for #{story.id} have been generated."
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
          model: "gpt-3.5-turbo", # Required.
          messages:,
          temperature: 0.7
        }
      )
    end
  end
end

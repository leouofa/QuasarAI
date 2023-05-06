class Images::CreateImageJob < ApplicationJob
  queue_as :default

  def perform(story:)
    @client = OpenAI::Client.new

    return if story.invalid_images
    return if story.images.count.positive?

    story.stem

    system_role = <<~SYSTEM_ROLE
      You are a senior graphics illustrator working for the New York times.
    SYSTEM_ROLE

    question = <<~QUESTION
      - You have received the following story in JSON format
      - The story is about `#{story.sub_topic.name}` and `#{story.tag.name}`.
      - It is your job to come up with 3 ai image ideas that support the story.
      - The each idea should be 4-5 sentences that support the story.
      - The image ideas should be different from each other.
      - Don't use real people or places in the image ideas.
      - Make sure the image ideas are violet or offensive.
      - Make images in sci-fi, cyberpunk, synthwave or fantasy styles.
      - The return result MUST be in JSON format in the following structure:

      ```
       images: [
          {
            "description": "image description"
          },
          {
            "description": "image description"
          }
       ]
      ```
    QUESTION

    brief = story.stem

    messages = [
      { role: "system", content: system_role },
      { role: "user", content: question },
      { role: "user", content: brief }
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

    if response["error"].present?
      story.update(invalid_images:)
    else
      image_ideas = JSON.parse(response["choices"][0]["message"]["content"])["images"]

      image_ideas.each do |idea|
        Image.create(story: story, idea: idea["description"])
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

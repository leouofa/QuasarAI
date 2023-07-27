class Stories::ModerateStoryJob < ApplicationJob
  queue_as :default
  include SettingsHelper

  def perform(story:)
    return unless story.approved.blank?

    @client = OpenAI::Client.new

    parsed_story = JSON.parse(story.stem)
    parsed_title = parsed_story['title']
    parsed_summary = parsed_story['summary']

    puts parsed_title
    puts parsed_summary
    puts '---'

    system_role = <<~SYSTEM_ROLE
        You are an experienced content moderator. You are reviewing potential stories to be published.
    SYSTEM_ROLE

    brief = <<~BRIEF
        You have received the following `news brief` with the title `#{parsed_title}` and summary
        """
        #{parsed_summary}
        """
    BRIEF

    question = <<~QUESTION
        - It is your job to return the word 'deny' if the `news brief` is promotional nature.
        - It is your job to return the word 'deny' if the `news brief` contains political content.
        - It is your job to return the word 'deny' if the `news brief` contains violent content.
        - It is your job to return the word 'deny' if the `news brief` sexually explicit content.
        - If the `news brief` is not promotional, political or violet return `approve`
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

      invalid_json = false if %[approve deny].include? response["choices"][0]["message"]["content"].downcase
      Rails.logger.debug "invalid_json: #{invalid_json} | counter: #{counter}"
    end

    if response["error"].present?
      story.update(approved: false, invalid_json:)
    else
      decision = response["choices"][0]["message"]["content"].downcase
      puts decision

      if decision == 'approve'
        story.update(approved: true)
      else
        story.update(approved: false)
      end

      puts '---'
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

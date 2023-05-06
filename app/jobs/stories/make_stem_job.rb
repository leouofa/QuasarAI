module Stories
  class MakeStemJob < ApplicationJob
    queue_as :default

    def perform(story:)
      return if story.processed

      @client = OpenAI::Client.new

      feed_items = []
      story.feed_items.each do |feed_item|
        feed_items << <<~FEED_ITEM
          Title: #{feed_item.title}
          URL: #{feed_item.url}#{' '}
          Author: #{feed_item.author}
          Published: #{feed_item.published}
          Topic: #{feed_item.feed.sub_topic.name}
          Subtopic: #{feed_item.feed.sub_topic.name}

          #{feed_item.markdown_content}
        FEED_ITEM
      end

      joined_feed_items = feed_items.join("\n\n\n\n")

      brief = <<~BRIEF
        Brief
        ---------------------------------------------------------
        #{joined_feed_items}
      BRIEF

      system_role = <<~SYSTEM_ROLE
        You are a senior reporter working for the New York times. DONT MAKE ANYTHING UP.
      SYSTEM_ROLE

      question = <<~QUESTION
        - You have received the following as a news brief about `#{story.sub_topic.name}` and `#{story.tag.name}`.
        - It is your job to write an article consisting of 6 sections, each section has the following format:
        ```
        + header
        -- paragraph1
        -- paragraph2
        -- paragraph3
        ```

        - The header should be a short single sentence that summarizes the section.
        - The paragraphs should be 4-5 sentences that support the header.
        - The article should have a title that summarizes the entire article.
        - The article should have a 4-5 sentence summary that summarizes the entire article.
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
        { role: "user", content: question },
        { role: "user", content: brief }
      ]


      invalid_json = true
      counter = 0
      response = nil

      while invalid_json && counter < 4 do
        response = chat(messages:)

        counter += 1

        break if response["error"].present?

        invalid_json = false if valid_json?(response["choices"][0]["message"]["content"])
        Rails.logger.debug "invalid_json: #{invalid_json} | counter: #{counter}"
      end

      if response["error"].present?
        story.update(processed: true, invalid_json:)
      else
        story.update(stem: response["choices"][0]["message"]["content"], processed: true, invalid_json:)
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
          model: "gpt-3.5-turbo", # Required.
          messages:,
          temperature: 0.7
        }
      )
    end

  end
end

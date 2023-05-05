module Stories
  class MakeStemJob < ApplicationJob
    queue_as :default

    def perform(story:)
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
         - You have received the following as a news brief about `#{story.tag.name}`.
         - It is your job to write an article consisting of 6 sections, each section has the following format:
         ```
         + header
         + generative_image_idea
         -- paragraph1
         -- paragraph2
         -- paragraph3
         ```

         - The header should be a short single sentence that summarizes the section.
         - The generative_image_idea should be a 1 - 2 sentences that describes the image that should be generated based on the contents of the header.#{' '}
         - Do not use names and places in the generative_image_idea, instead focus on archetypes.
         - The paragraphs should be 3-5 sentences that support the header.
         - The article should have a title that summarizes the entire article.
         - The return result must be in json format in the following structure:
         ```#{' '}
          title: "article title"
          content: [
             {
               "header": "header text",
               "generative_image_idea": "image idea"
               "paragraphs": ["paragraph1 text", "paragraph2 text", paragraph3 text"]
             },
             {
               "header": "header text",
               "generative_image_idea": "image idea"
               "paragraphs": ["paragraph1 text", "paragraph2 text", paragraph3 text"]
             }
          ]#{'    '}
        ````
      QUESTION


      messages = [
        { role: "system", content: system_role },
        { role: "user", content: question },
        { role: "user", content: brief }
      ]

      # response = chat(messages:)
      #
      # invalid_json = if valid_json?(response["choices"][0]["message"]["content"])
      #                  false
      #                else
      #                  true
      #                end

      invalid_json = true
      counter = 0

      while invalid_json && counter < 3 do
        response = chat(messages:)

        counter += 1
        invalid_json = false if valid_json?(response["choices"][0]["message"]["content"])
                       #   false
                       # else
                       #   true
                       # end
        puts "invalid_json: #{invalid_json} | counter: #{counter}"
      end


      story.update(stem: response["choices"][0]["message"]["content"], processed: true, invalid_json:)
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

class Articles::RewriteArticleJob < ApplicationJob
  queue_as :default

  def perform(article:)
    linked_articles = article.linked_articles

    return if linked_articles.empty?

    @client = OpenAI::Client.new

    system_role = <<~SYSTEM_ROLE
        You are a senior content writer, experienced in SEO, working for a digital agency. 
        DONT MAKE ANYTHING UP.
    SYSTEM_ROLE

    linked_articles_json_string = article.linked_articles.pluck(:id, :name, :description).map do |id, name, description|
      { id: id, name: name, description: description }
    end.to_json


    brief = <<~BRIEF
        You have received the following original blog post in JSON format:

        #{article.original_text.to_json}

        You have also received 3 related blog posts to the story in JSON format:
        #{linked_articles_json_string}
    BRIEF

    question = <<~QUESTION
        - It is your job to re-write the original blog posts, and blend in links from 3 related blog posts 
          into the new content.
        - Links should be inside the paragraphs, wrapped in <a> tags, 
          and include the id of the linked article in `href`. Like so:
          ```
          <a href=post-id-123>Related Content</a>.
          ```
        - There can only be 3 links per blog post
        - The new blog post consist of 6 sections, each section has the following format:
        ```
        + header
        -- paragraph1
        -- paragraph2
        -- paragraph3
        ```
        - Attempt to sandwich the link inside of the middle of the paragraph.
        - The `header` should be no more then 80 characters long sentence and summarizes the section.
        - The `paragraphs` should be 4-5 sentences that support the `header`.
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

      extracted_json_response = extract_json_from_string(response["choices"][0]["message"]["content"])
      invalid_json = false if valid_json?(extracted_json_response)

      Rails.logger.debug "invalid_json: #{invalid_json} | counter: #{counter}"

      sleep(20)
    end

    unless response["error"].present? || invalid_json
      parsed_response = JSON.parse(extracted_json_response)

      article.update(rewritten_text: parsed_response["content"])

    end

    sleep(10)
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

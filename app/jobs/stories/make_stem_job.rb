class Stories::MakeStemJob < ApplicationJob
  queue_as :default

  def perform(story:)

    feed_items = []
    story.feed_items.each do |feed_item|
      feed_items << <<~FEED_ITEM
        Title: #{feed_item.title}
        URL: #{feed_item.url} 
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
       -- paragraph1
       -- paragraph2
       -- paragraph3
       ```

       - The header should be a single sentence that summarizes the section.
       - The paragraphs should be 4-5 sentences that support the header.
       - The return result must be in json format in the following structure:
       ``` 
        [
           {
             "header": "header text",
             "paragraphs": ["paragraph1 text", "paragraph2 text", paragraph3 text"]
           },
           {
             "header": "header text",
             "paragraphs": ["paragraph1 text", "paragraph2 text", paragraph3 text"]
           }
        ]    
      ````
    QUESTION


    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [
          { role: "system", content: system_role },
          { role: "user", content: question},
          { role: "user", content: brief}
        ], # Required.
        temperature: 0.7,
      })

    story.update(stem: response["choices"][0]["message"]["content"])
  end
end

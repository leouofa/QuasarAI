class Instapins::PublishInstapinJob < ApplicationJob
  queue_as :default

  def perform(discussion:)
    return if discussion.instapin.uploaded

    story = discussion.story
    instapin = discussion.instapin

    platforms = []
    platforms.push 'pinterest' if ENV['PINTEREST_ENABLED']
    platforms.push 'instagram' if ENV['INSTAGRAM_ENABLED']

    instapin_text = JSON.parse(instapin.stem)['post']

    if story.sub_topic.ai_disclaimer
      instapin_text = "📟 AI Perspective: #{instapin_text}"
    end

    max_characters = 400
    auto_hashtag = false

    # Truncate tweet_text to fit within the MAX_CHARACTERS limit
    # 31 characters are reserved for URL and a space
    truncated_instapin_text = instapin_text.truncate(max_characters - 31, omission: '...')

    card_images =  discussion.story.imaginations.where(aspect_ratio: :landscape).sample(3)

    card_image_urls = card_images.map do |card_image|
      "https://ucarecdn.com/#{card_image.uploadcare.last['uuid']}/-/format/auto/-/quality/smart/-/resize/1440x/"
    end

    story_pro_discussion = StoryPro.get_discussion(discussion.story_pro_id)
    discussion_slug = story_pro_discussion["entry"]["slug"]
    category_slug = get_story_pro_category_slug(story)

    discussion_url = "#{ENV['STORYPRO_URL']}/discussions/#{category_slug}/#{discussion_slug}"

    full_instapin =  "#{truncated_instapin_text} \n\n Read full story at: #{discussion_url}"

    return if platforms.blank?


    if  platforms.include? 'instagram'
      Ayrshare.post_message(post: full_instapin, platforms: ['instagram'] , media_urls: card_image_urls, auto_hashtag:)
    end

    if  platforms.include? 'pinterest'
      Ayrshare.post_pinterest_message(post: truncated_instapin_text,
                                      platforms: ['pinterest'] ,
                                      media_urls: card_image_urls.sample(1),
                                      pinterest_options: {
                                        title: discussion.parsed_stem["title"].truncate(100),
                                        link: discussion_url,
                                        boardId: story.sub_topic.pinterest_board
                                      })
    end

    instapin.update(uploaded: true, published_at: Time.now.utc)
  end

  def get_story_pro_category_slug(story)
    story_pro_categories = StoryPro.get_categories
    found_story_pro_category = story_pro_categories.find { |c| c["id"] == story.sub_topic.storypro_category_id }
    found_story_pro_category['slug']
  end
end

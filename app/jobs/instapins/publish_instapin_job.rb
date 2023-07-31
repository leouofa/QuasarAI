class Instapins::PublishInstapinJob < ApplicationJob
  queue_as :default

  def perform(discussion:)
    return if discussion.instapin.uploaded

    story = discussion.story
    instapin = discussion.instapin

    platforms = []
    platforms.push 'pinterest' if ENV['PINTEREST_ENABLED']
    platforms.push 'instagram' if ENV['INSTAGRAM_ENABLED']
    platforms.push 'facebook' if ENV['FACEBOOK_ENABLED']

    instapin_text = JSON.parse(instapin.stem)['post']

    if story.sub_topic.ai_disclaimer
      instapin_text = "📟 AI Perspective: #{instapin_text}"
    end

    max_characters = 400

    # Truncate truncated_instapin_text to fit within the max_characters limit
    # 31 characters are reserved for URL and a space
    truncated_instapin_text = instapin_text.truncate(max_characters - 31, omission: '...')

    landscape_images =  discussion.story.imaginations.where(aspect_ratio: :landscape).sample(3)

    landscape_image_urls = landscape_images.map do |landscape_image|
      "https://ucarecdn.com/#{landscape_image.uploadcare.last['uuid']}/-/format/auto/-/quality/smart/-/resize/1440x/"
    end


    story_pro_discussion = StoryPro.get_discussion(discussion.story_pro_id)
    discussion_slug = story_pro_discussion["entry"]["slug"]
    category_slug = get_story_pro_category_slug(story)

    discussion_url = "#{ENV['STORYPRO_URL']}/discussions/#{category_slug}/#{discussion_slug}"

    full_instapin =  "#{truncated_instapin_text} \n\n Read full story at: #{discussion_url}"

    carousel_items = landscape_image_urls.map do |landscape_url|
      {
        name: discussion.parsed_stem["title"].truncate(50),
        link: discussion_url,
        picture: landscape_url
      }
    end

    return if platforms.blank?


    if  platforms.include? 'instagram'
      Ayrshare.post_message(post: full_instapin, platforms: ['instagram'] , media_urls: landscape_image_urls)
    end

    if  platforms.include? 'pinterest'
      Ayrshare.post_pinterest_message(post: truncated_instapin_text,
                                      platforms: ['pinterest'] ,
                                      media_urls: landscape_image_urls.sample(1),
                                      pinterest_options: {
                                        title: discussion.parsed_stem["title"].truncate(100),
                                        link: discussion_url,
                                        boardId: story.sub_topic.pinterest_board
                                      })
    end

    # if  platforms.include? 'facebook'
    #     Ayrshare.post_carousel(post: truncated_instapin_text,
    #                                     facebook_options: {
    #                                       carousel: {
    #                                         link: discussion_url,
    #                                         items: carousel_items
    #                                       }
    #                                     })
    # end


    instapin.update(uploaded: true, published_at: Time.now.utc)
  end

  def get_story_pro_category_slug(story)
    story_pro_categories = StoryPro.get_categories
    found_story_pro_category = story_pro_categories.find { |c| c["id"] == story.sub_topic.storypro_category_id }
    found_story_pro_category['slug']
  end
end

class Tweets::PublishTweetJob < ApplicationJob
  queue_as :default

  def perform(discussion:)
    return if discussion.tweet.uploaded

    story = discussion.story
    tweet = discussion.tweet

    platforms = []
    platforms.push 'twitter' if ENV['TWITTER_ENABLED']
    platforms.push 'linkedin' if ENV['LINKEDIN_ENABLED']
    platforms.push 'facebook' if ENV['FACEBOOK_ENABLED']

    tweet_text = JSON.parse(tweet.stem)['tweet']

    if story.sub_topic.ai_disclaimer
      tweet_text = "📟 AI Perspective: #{tweet_text}"
    end

    max_characters = 280
    auto_hashtag = false

    # Truncate tweet_text to fit within the MAX_CHARACTERS limit
    # 31 characters are reserved for URL and a space
    truncated_tweet_text = tweet_text.truncate(max_characters - 31, omission: '...')

    card_image =  tweet.discussion.story.imaginations.where(aspect_ratio: :card).sample(1)
    card_image_url = "https://ucarecdn.com/#{card_image.last.uploadcare.last['uuid']}/-/format/auto/-/quality/smart/-/preview/"

    story_pro_discussion = StoryPro.get_discussion(discussion.story_pro_id)
    discussion_slug = story_pro_discussion["entry"]["slug"]
    category_slug = get_story_pro_category_slug(story)

    discussion_url = "#{ENV['STORYPRO_URL']}/discussions/#{category_slug}/#{discussion_slug}"

    full_tweet =  "#{truncated_tweet_text} #{discussion_url}"

    return if platforms.blank?

    # Ayrshare.post_message(post: full_tweet, platforms: , media_urls: [card_image_url], auto_hashtag:)
    Ayrshare.post_plain_message(post: full_tweet, platforms:, auto_hashtag:)
    tweet.update(uploaded: true, published_at: Time.now.utc)
  end

  def get_story_pro_category_slug(story)
    story_pro_categories = StoryPro.get_categories
    found_story_pro_category = story_pro_categories.find { |c| c["id"] == story.sub_topic.storypro_category_id }
    found_story_pro_category['slug']
  end
end

class Tweets::PublishTweetJob < ApplicationJob
  queue_as :default

  def perform(discussion:)
    return if discussion.tweet.uploaded

    story = discussion.story
    tweet = discussion.tweet

    tweet_text = JSON.parse(tweet.stem)['tweet']
    card_image =  tweet.discussion.story.imaginations.where(aspect_ratio: :card).sample(1)
    card_image_url = "https://ucarecdn.com/#{card_image.last.uploadcare.last['uuid']}/"


    story_pro_discussion = StoryPro.get_discussion(discussion.story_pro_id)
    discussion_slug = story_pro_discussion["entry"]["slug"]
    category_slug = get_story_pro_category_slug(story)

    discussion_url = "#{ENV['STORYPRO_URL']}/discussions/#{category_slug}/#{discussion_slug}"

    full_tweet =  "#{tweet_text} #{discussion_url}"
    Ayrshare.post_message(post: full_tweet, platforms: ['twitter'], media_urls: [card_image_url])

    tweet.update(uploaded: true)
  end

  def get_story_pro_category_slug(story)
    story_pro_categories = StoryPro.get_categories
    found_story_pro_category = story_pro_categories.find { |c| c["id"] == story.sub_topic.storypro_category_id }
    found_story_pro_category['slug']
  end
end

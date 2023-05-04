class AssembleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Get New Feeds
    Feeds::GetSubTopicFeedsJob.perform_now

    # Create Feed Items From Feeds
    FeedItems::ProcessJob.perform_now

    # Convert HTML to Markdown
    FeedItems::ConvertHtmlToMarkdownJob.perform_now

    # Process SubTopics into Stories
    Stories::ProcessSubtopicsJob.perform_now

  end
end

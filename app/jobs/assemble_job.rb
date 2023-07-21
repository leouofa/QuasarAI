class AssembleJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Try to acquire a lock
    lock = Lock.find_or_create_by(name: 'AssembleJob')

    return if lock.locked?

    # Lock the job
    lock.update(locked: true)

    begin
      # [x] Get New Feeds
      Feeds::CreateFeedsFromSubtopicsJob.perform_now

      # [x] Create Feed Items From Feeds
      FeedItems::CreateFeedItemsJob.perform_now

      # [x] Convert HTML to Markdown
      FeedItems::ConvertHtmlToMarkdownJob.perform_now

      # [x] Creates stories based on subtopics
      Stories::CreateStoriesFromSubtopicsJob.perform_now

      # [x] Create Stemmed Stories
      Stories::ProcessStoryStemsJob.perform_now

      # [x] Kill Spammy Stories
      Stories::KillSpammyStoriesJob.perform_now

      # [x] Images from processed stories
      Images::CreateImageIdeasFromStoriesJob.perform_now

      # [x] Cleanup broken imaginations
      Images::CleanupImaginationsJob.perform_now

      # [x] Upload Imaginations to Uploadcare
      Images::UploadImaginationsJob.perform_now

      # [x] Mark Images with uploaded Imaginations as uploaded
      Images::MarkUploadedImagesJob.perform_now

      # [x] Create Discussions from Stories
      Discussions::ProcessDiscussionStemsJob.perform_now

      # [x] Create Tweets from Discussions
      Tweets::ProcessTwitterStemsJob.perform_now
    ensure
      # Unlock the job when finished
      lock.update(locked: false)
    end
  end
end

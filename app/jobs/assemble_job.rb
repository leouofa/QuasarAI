class AssembleJob < ApplicationJob
  queue_as :default

  def perform(*_args)
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

    # [x] Images from processed stories
    Images::CreateImageIdeasFromStoriesJob.perform_now

    # [x] Create Imaginations from Image Ideas
    Images::ImagineImagesJob.perform_now

    # [x] Upload Imaginations to Uploadcare
    Images::UploadImaginationsJob.perform_now
  end
end

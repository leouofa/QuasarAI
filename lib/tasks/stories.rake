namespace :stories do
  desc 'Resetting stories'
  task reset: :environment do
    puts 'resetting stories'

    Feed.update_all(processed: false)
    StoryTag.delete_all
    Assignment.delete_all
    Story.delete_all
    Tagging.delete_all
    FeedItem.delete_all
    Tag.delete_all
  end

  # We need this to approve stories that were created prior to the approval process being implemented
  desc 'Approve stories that already have discussions'
  task approve_stories_with_discussions: :environment do
    Story.joins(:discussion).update_all(approved: true)
  end
end

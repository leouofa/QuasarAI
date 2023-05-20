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
end

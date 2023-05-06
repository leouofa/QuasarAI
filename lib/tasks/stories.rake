namespace :stories do
  desc 'Resetting stories'
  task reset: :environment do
    puts 'resetting stories'

    # Feed.update_all(processed: false)
    FeedItem.update_all(processed: false)
    StoryTag.delete_all
    Assignment.delete_all
    Story.delete_all
  end
end

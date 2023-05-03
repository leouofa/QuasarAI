module FeedItems
  class ConvertHtmlToMarkdownJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      FeedItem.where(markdown_content: nil).all.each do |feed_item|
        feed_item.update(markdown_content: ReverseMarkdown.convert(feed_item.content))
      end
    end
  end
end

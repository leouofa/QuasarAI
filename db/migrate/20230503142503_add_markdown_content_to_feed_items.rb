class AddMarkdownContentToFeedItems < ActiveRecord::Migration[7.0]
  def change
    add_column :feed_items, :markdown_content, :text, default: nil
  end
end

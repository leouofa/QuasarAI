module ApplicationHelper
  def markdown(text)
    options = %i[
      hard_wrap autolink no_intra_emphasis tables fenced_code_blocks
      disable_indented_code_blocks strikethrough lax_spacing space_after_headers
      quote footnotes highlight underline no_images
    ]
    Markdown.new(text, *options).to_html.html_safe
  end

  def menu_active?(test_path)
    return 'active' if request.path == test_path

    ''
  end

  def highlight_hashtags(tweet)
    return "<p class='text-red-700'>The tweet is empty. Please click `edit` to create it.</p>".html_safe if tweet.blank?

    tweet.gsub(/#\w+/) do |hashtag|
      "<strong class='text-blue-800'>#{hashtag}</strong>"
    end.html_safe
  end
end

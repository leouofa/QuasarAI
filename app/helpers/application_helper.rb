module ApplicationHelper
  def markdown(text)
    options = %i[
      hard_wrap autolink no_intra_emphasis tables fenced_code_blocks
      disable_indented_code_blocks strikethrough lax_spacing space_after_headers
      quote footnotes highlight underline
    ]
    Markdown.new(text, *options).to_html.html_safe
  end
  def menu_active?(test_path)
    return 'active' if request.path == test_path

    ''
  end
end

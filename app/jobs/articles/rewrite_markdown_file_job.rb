class Articles::RewriteMarkdownFileJob < ApplicationJob
  queue_as :default

  def perform(article:)
    puts article.name
    last_mod = add_random_days(article.published_at).strftime("%Y-%m-%d")

    markdown_content = generate_markdown(article:, last_mod:)

    begin
      linked_content = replace_links(markdown_content)

      file_path = Rails.root.join('public', 'rewritten_articles', "#{article.name.parameterize}.mdx")

      File.open(file_path, 'w') { |file| file.write(linked_content) }

      article.update(rewritten_at: last_mod)
    rescue => e
      Rails.logger.error "Failed to replace links or write file for article #{article.id}: #{e.message}"
    end
  end

  private

  def generate_markdown(article:, last_mod:)
    <<~MARKDOWN
      ---
      title: "#{article.name}"
      date: '#{article.published_at.strftime("%Y-%m-%d")}'
      lastmod: '#{last_mod}'
      tags: ['#{article.pillar_column.name}']
      draft: false
      summary: #{article.description}
      ---

      #{article.rewritten_text.map { |section| format_section(section) }.join("\n\n")}
    MARKDOWN
  end

  def format_section(section)
    header = "## #{section['header']}"
    paragraphs = section['paragraphs'].map { |paragraph| paragraph.to_s }.join("\n\n")

    "#{header}\n\n#{paragraphs}"
  end

  def add_random_days(date)
    # Generate a random number between 1 and 7
    random_days = rand(1..7).day
    # Add the random number of days to the date
    new_date = date + random_days
    new_date
  end

  def replace_links(content)
    content.gsub(/<a href[^>]*?(\d+)[^>]*>/) do |match|
      number = match[/\d+/].to_i
      link_lookup(number)
    end
  end

  def link_lookup(id)
    linked_article = Article.find(id)
    "<a href='/blog/#{linked_article.name.parameterize}'>"
  end
end

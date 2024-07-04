class Articles::CreateMarkdownFileJob < ApplicationJob
  queue_as :default

  def perform(article:)
    article_date = random_date_within_6_months.strftime("%Y-%m-%d")

    markdown_content = generate_markdown(article:, article_date:)

    file_path = Rails.root.join('public', 'articles', "#{article.name.parameterize}.mdx")
    File.open(file_path, 'w') { |file| file.write(markdown_content) }

    article.update(published_at: article_date)
  end

  private

  def generate_markdown(article:, article_date:)
    <<~MARKDOWN
      ---
      title: "#{article.name}"
      date: '#{article_date}'
      tags: ['#{article.pillar_column.name}']
      draft: false
      summary: #{article.description}
      ---

      #{article.original_text.map { |section| format_section(section) }.join("\n\n")}
    MARKDOWN
  end

  def format_section(section)
    header = "## #{section['header']}"
    paragraphs = section['paragraphs'].map { |paragraph| paragraph.to_s }.join("\n\n")

    "#{header}\n\n#{paragraphs}"
  end

  def random_date_within_6_months
    now = Time.current
    past_date = 6.months.ago
    Time.at(rand(past_date.to_f..now.to_f))
  end
end

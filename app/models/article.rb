# == Schema Information
#
# Table name: articles
#
#  id               :bigint           not null, primary key
#  name             :string
#  description      :string
#  pillar_column_id :bigint           not null
#  original_text    :text
#  rewritten_text   :text
#  published_at     :datetime
#  rewritten_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  embedding        :vector(768)
#
class Article < ApplicationRecord
  belongs_to :pillar_column
  serialize :original_text

  has_neighbors :embedding

  has_many :article_links, dependent: :nullify
  has_many :linked_articles, through: :article_links, source: :linked_article, source_type: 'Article'

  validates :name, :description, :original_text, presence: true
  validate :linked_articles_count_within_limit

  scope :without_embedding, -> { where(embedding: nil) }
  scope :without_three_links, lambda {
    left_joins(:article_links)
      .group(:id)
      .having('COUNT(article_links.id) < 3')
  }

  scope :with_three_links, lambda {
    joins(:article_links)
      .group('articles.id')
      .having('COUNT(article_links.id) = 3')
  }

  private

  def linked_articles_count_within_limit
    return unless linked_articles.size > 3

    errors.add(:linked_articles, "cannot exceed 3")
  end
end

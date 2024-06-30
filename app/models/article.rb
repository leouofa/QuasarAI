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

  has_many :article_links
  has_many :linked_articles, through: :article_links, source: :linked_article, source_type: 'Article'

  validates :name, :description, :original_text, presence: true
  validate :linked_articles_count_within_limit

  scope :without_embedding, -> { where(embedding: nil) }

  private

  def linked_articles_count_within_limit
    return unless linked_articles.size > 3

    errors.add(:linked_articles, "cannot exceed 3")
  end
end

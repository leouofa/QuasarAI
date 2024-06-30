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

  validates :name, :description, :original_text, presence: true

  scope :without_embedding, -> { where(embedding: nil) }

  has_many :article_links
  has_many :linked_articles, through: :article_links, source: :linked_article, source_type: 'Article'

  validate :linked_articles_count_within_limit

  private

  def linked_articles_count_within_limit
    if linked_articles.size > 3
      errors.add(:linked_articles, "cannot exceed 3")
    end
  end
end

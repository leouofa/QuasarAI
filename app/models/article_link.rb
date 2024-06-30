class ArticleLink < ApplicationRecord
  belongs_to :article
  belongs_to :linked_article, polymorphic: true

  validate :article_cannot_link_to_itself

  private

  def article_cannot_link_to_itself
    return unless article_id == linked_article_id

    errors.add(:linked_article, "can't be the same as the article")
  end
end

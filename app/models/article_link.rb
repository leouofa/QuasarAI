# == Schema Information
#
# Table name: article_links
#
#  id                  :bigint           not null, primary key
#  article_id          :bigint           not null
#  linked_article_type :string           not null
#  linked_article_id   :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
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

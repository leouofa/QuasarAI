require 'rails_helper'

RSpec.describe ArticleLink, type: :model do
  it "is valid with valid attributes" do
    article_link = create(:article_link)
    expect(article_link).to be_valid
  end

  it "is invalid if an article links to itself" do
    article = create(:article)
    article_link = build(:article_link, article: article, linked_article: article)
    expect(article_link).not_to be_valid
    expect(article_link.errors[:linked_article]).to include("can't be the same as the article")
  end
end

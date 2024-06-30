require 'rails_helper'

RSpec.describe Article, type: :model do
  it "is valid with valid attributes" do
    article = create(:article)
    expect(article).to be_valid
  end

  it "is invalid without a name" do
    article = build(:article, name: nil)
    expect(article).not_to be_valid
  end

  it "is invalid without a description" do
    article = build(:article, description: nil)
    expect(article).not_to be_valid
  end

  it "is invalid without original text" do
    article = build(:article, original_text: nil)
    expect(article).not_to be_valid
  end

  it "cannot have more than 3 linked articles" do
    article = create(:article)
    3.times { article.linked_articles << create(:article) }
    expect(article).to be_valid

    article.linked_articles << create(:article)
    expect(article).not_to be_valid
  end

  it "cannot link to itself" do
    article = create(:article)
    article_link = build(:article_link, article: article, linked_article: article)
    expect(article_link).not_to be_valid
    expect(article_link.errors[:linked_article]).to include("can't be the same as the article")
  end
end

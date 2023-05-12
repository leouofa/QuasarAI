require 'rails_helper'

RSpec.describe FeedItem, type: :model do
  describe 'associations' do
    it { should belong_to(:feed) }
    it { should have_many(:taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:taggings) }
    it { should have_one(:assignment).dependent(:destroy) }
    it { should have_one(:story).through(:assignment) }
  end

  describe 'jsonb_accessor' do
    it 'should have payload attributes' do
      feed_item = create(:feed_item)
      expect(feed_item).to respond_to(:title)
      expect(feed_item).to respond_to(:url)
      expect(feed_item).to respond_to(:author)
      expect(feed_item).to respond_to(:crawled)
      expect(feed_item).to respond_to(:published)
    end
  end

  describe 'factory' do
    it 'creates a valid feed_item' do
      feed_item = build(:feed_item)
      expect(feed_item).to be_valid
    end
  end
end

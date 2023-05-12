require 'rails_helper'

RSpec.describe Stories::CreateStoriesJob, type: :job do
  describe '#perform' do
    let(:sub_topic) { create(:sub_topic, min_tags_for_story: 2) }
    let(:feed) { create(:feed, sub_topic: sub_topic) }
    let!(:tag1) { create(:tag, name: 'tag1') }
    let!(:tag2) { create(:tag, name: 'tag2') }
    let!(:tag3) { create(:tag, name: 'tag3') }
    let!(:feed_items) do
      [
        create(:feed_item, feed: feed, tags: [tag1, tag2]),
        create(:feed_item, feed: feed, tags: [tag1, tag2, tag3]),
        create(:feed_item, feed: feed, tags: [tag1, tag2, tag3]),
        create(:feed_item, feed: feed, tags: [tag1, tag2, tag3]),
        create(:feed_item, feed: feed, tags: [tag1, tag2]),
        create(:feed_item, feed: feed, tags: [tag1, tag3])
      ]
    end

    subject(:job) { described_class.perform_now(sub_topic: sub_topic) }

    it 'creates a story with the most frequent tag and minimum tags for story' do
      expect { job }.to change { FeedItem.where(processed: true).count }.by(6)
      expect(Story.last.tag).to eq(tag1)
      expect(Story.last.feed_items.count).to eq(sub_topic.min_tags_for_story)
    end

    it 'sets feed items as processed' do
      expect { job }.to change { FeedItem.processed.count }.by(6)
    end
  end
end

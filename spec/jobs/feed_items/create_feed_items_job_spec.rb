# spec/jobs/feed_items/create_feed_items_job_spec.rb

require 'rails_helper'

RSpec.describe FeedItems::CreateFeedItemsJob, type: :job do
  include ActiveJob::TestHelper

  let(:sub_topic) { create(:sub_topic) }
  let!(:unprocessed_feed) { create(:feed, sub_topic: sub_topic, processed: false) }

  describe '#perform_later' do
    it 'enqueues the job' do
      expect { described_class.perform_later }.to have_enqueued_job(described_class)
    end
  end

  describe '#perform' do
    let(:items) do
      [
        {
          'title' => 'Test Title',
          'fullContent' => 'Test Content',
          'id' => 'unique-uuid',
          'author' => 'Test Author',
          'crawled' => 1_625_000_000_000,
          'published' => 1_625_000_000_000,
          'canonicalUrl' => 'https://example.com/test-url',
          'commonTopics' => [
            { 'label' => 'Topic 1' },
            { 'label' => 'Topic 2' },
          ],
        },
      ]
    end

    before do
      allow(Feed).to receive(:unprocessed).and_return([unprocessed_feed])
      unprocessed_feed.update(payload: { 'items' => items })
      described_class.perform_now
    end

    it 'creates a feed item' do
      expect(FeedItem.count).to eq(1)
      feed_item = FeedItem.first
      expect(feed_item.title).to eq('Test Title')
      expect(feed_item.content).to eq('Test Content')
      expect(feed_item.uuid).to eq('unique-uuid')
      expect(feed_item.author).to eq('Test Author')
      expect(feed_item.url).to eq('https://example.com/test-url')
    end

    it 'creates tags for the feed item' do
      feed_item = FeedItem.first
      expect(feed_item.tags.count).to eq(2)
      expect(feed_item.tags.map(&:name)).to contain_exactly('Topic 1', 'Topic 2')
    end

    it 'marks the feed as processed' do
      expect(unprocessed_feed.reload.processed).to be(true)
    end
  end
end

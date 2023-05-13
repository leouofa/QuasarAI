# == Schema Information
#
# Table name: feeds
#
#  id           :bigint           not null, primary key
#  sub_topic_id :bigint           not null
#  payload      :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  processed    :boolean          default(FALSE)
#  error        :boolean          default(FALSE)
#
# spec/models/feed_spec.rb

require 'rails_helper'

RSpec.describe Feed, type: :model do
  before(:each) do
    Feed.destroy_all
  end

  describe 'associations' do
    it { should belong_to(:sub_topic) }
    it { should have_many(:feed_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:sub_topic_id) }
  end

  describe 'scopes' do
    let!(:feed_1) { create(:feed, processed: false, error: false) }
    let!(:feed_2) { create(:feed, processed: true, error: false) }
    let!(:feed_3) { create(:feed, processed: false, error: true) }

    context 'unprocessed' do
      it 'returns feeds that are not processed and not in error state' do
        expect(Feed.unprocessed).to contain_exactly(feed_1)
      end
    end
  end
end

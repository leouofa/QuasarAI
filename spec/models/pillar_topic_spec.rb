# == Schema Information
#
# Table name: pillar_topics
#
#  id               :bigint           not null, primary key
#  title            :string
#  summary          :text
#  pillar_column_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  processed        :boolean          default(FALSE)
#
# spec/models/pillar_topic_spec.rb

require 'rails_helper'

RSpec.describe PillarTopic, type: :model do
  let(:pillar_column) { create(:pillar_column) }
  let(:pillar_topic) { create(:pillar_topic, pillar_column: pillar_column) }

  it { should belong_to(:pillar_column) }

  it 'validates uniqueness of title scoped to pillar_column_id' do
    create(:pillar_topic, title: 'Unique Title', pillar_column: pillar_column)
    should validate_uniqueness_of(:title).scoped_to(:pillar_column_id)
  end

  it 'validates uniqueness of summary scoped to pillar_column_id' do
    create(:pillar_topic, summary: 'Unique Summary', pillar_column: pillar_column)
    should validate_uniqueness_of(:summary).scoped_to(:pillar_column_id)
  end

  describe 'scopes' do
    let!(:processed_topic) { create(:pillar_topic, processed: true, pillar_column: pillar_column) }
    let!(:unprocessed_topic) { create(:pillar_topic, processed: false, pillar_column: pillar_column) }

    it 'returns processed topics' do
      expect(PillarTopic.processed).to include(processed_topic)
      expect(PillarTopic.processed).not_to include(unprocessed_topic)
    end
  end
end

require 'rails_helper'

RSpec.describe Pillars::CreatePillarTopicsJob, type: :job do
  let!(:pillar_column_with_topics) do
    create(:pillar_column,
           topics: [{ "title" => "Topic 1", "summary" => "Summary 1" }, { "title" => "Topic 2", "summary" => "Summary 2" }])
  end
  let!(:pillar_column_without_topics) { create(:pillar_column, topics: nil) }
  let!(:processed_pillar_column) do
    create(:pillar_column, topics: [{ "title" => "Topic 3", "summary" => "Summary 3" }], processed: true)
  end

  describe '#perform' do
    it 'processes unprocessed pillar columns with topics' do
      expect { described_class.perform_now }.to change { PillarTopic.count }.by(2)

      pillar_column_with_topics.reload
      expect(pillar_column_with_topics.processed).to be_truthy
    end

    it 'does not process already processed pillar columns' do
      expect { described_class.perform_now }.not_to(change { processed_pillar_column.pillar_topics.count })
    end

    it 'does not process pillar columns without topics' do
      expect { described_class.perform_now }.not_to(change { pillar_column_without_topics.pillar_topics.count })
    end
  end
end

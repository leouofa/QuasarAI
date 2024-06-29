# == Schema Information
#
# Table name: pillar_columns
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  pillar_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  topics      :text
#  processed   :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe PillarColumn, type: :model do
  let(:pillar_column) { create(:pillar_column) }

  it { should belong_to(:pillar) }
  it { should have_many(:pillar_topics) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  describe 'scopes' do
    let!(:column_with_topics) { create(:pillar_column, topics: ['Topic 1', 'Topic 2']) }
    let!(:column_without_topics) { create(:pillar_column, topics: nil) }

    it 'returns columns without topics' do
      expect(PillarColumn.without_topics).to include(column_without_topics)
      expect(PillarColumn.without_topics).not_to include(column_with_topics)
    end

    it 'returns columns with topics' do
      expect(PillarColumn.with_topics).to include(column_with_topics)
      expect(PillarColumn.with_topics).not_to include(column_without_topics)
    end
  end
end

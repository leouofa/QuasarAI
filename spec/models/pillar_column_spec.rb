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
#
# spec/models/pillar_column_spec.rb
require 'rails_helper'

RSpec.describe PillarColumn, type: :model do
  let(:pillar_column) { create(:pillar_column) }

  it { should belong_to(:pillar) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
end


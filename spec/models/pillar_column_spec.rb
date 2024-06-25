# spec/models/pillar_column_spec.rb
require 'rails_helper'

RSpec.describe PillarColumn, type: :model do
  let(:pillar_column) { create(:pillar_column) }

  it { should belong_to(:pillar) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
end


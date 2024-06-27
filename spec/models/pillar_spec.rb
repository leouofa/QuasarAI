# == Schema Information
#
# Table name: pillars
#
#  id         :bigint           not null, primary key
#  title      :string
#  columns    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# spec/models/pillar_spec.rb
require 'rails_helper'

RSpec.describe Pillar, type: :model do
  let(:pillar) { create(:pillar) }

  it { should have_many(:pillar_columns) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:columns) }
end


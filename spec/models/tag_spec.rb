require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should have_many(:taggings).dependent(:destroy) }
  it { should have_many(:feed_items).through(:taggings) }
end

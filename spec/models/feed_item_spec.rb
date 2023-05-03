require 'rails_helper'

RSpec.describe FeedItem, type: :model do
  it { should have_many(:taggings).dependent(:destroy) }
  it { should have_many(:tags).through(:taggings) }
end
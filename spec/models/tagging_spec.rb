RSpec.describe Tagging, type: :model do
  it { should belong_to(:feed_item) }
  it { should belong_to(:tag) }
end
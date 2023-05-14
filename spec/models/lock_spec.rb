require 'rails_helper'

RSpec.describe Lock, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:lock)).to be_valid
  end

  it "is invalid without a name" do
    expect(FactoryBot.build(:lock, name: nil)).to_not be_valid
  end

  it "does not allow duplicate names" do
    FactoryBot.create(:lock, name: "UniqueJob")
    expect(FactoryBot.build(:lock, name: "UniqueJob")).to_not be_valid
  end

  it "is not locked by default" do
    expect(FactoryBot.build(:lock).locked).to eq(false)
  end
end

FactoryBot.define do
  factory :discussion do
    story
    stem { "Some text" }
    processed { false }
    invalid_json { false }
    uploaded { false }
  end
end

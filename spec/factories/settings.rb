FactoryBot.define do
  factory :setting do
    topics { [] }
    prompts { [] }
    tunings { [] }
    pillars do
      [
        { 'name' => 'Business', 'columns' => 20 },
        { 'name' => 'Gaming', 'columns' => 20 },
        { 'name' => 'Music', 'columns' => 20 }
      ]
    end
  end
end

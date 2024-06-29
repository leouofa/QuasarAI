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
#
FactoryBot.define do
  factory :pillar_column do
    sequence(:name) { |n| "Column Name #{n}" }
    description { "Sample description for the pillar column." }
    association :pillar

    after(:create) do |pillar_column|
      create_list(:pillar_topic, 3, pillar_column: pillar_column)
    end
  end
end

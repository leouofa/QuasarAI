# == Schema Information
#
# Table name: settings
#
#  id                 :bigint           not null, primary key
#  topics             :text
#  prompts            :text
#  tunings            :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  publish_start_time :time             default(Sat, 01 Jan 2000 08:00:00.000000000 UTC +00:00)
#  publish_end_time   :time             default(Sat, 01 Jan 2000 21:00:00.000000000 UTC +00:00)
#  pillars            :text
#
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

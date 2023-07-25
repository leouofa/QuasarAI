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
#  publish_end_time   :time
#
class Setting < ApplicationRecord
  serialize :topics
  serialize :prompts
  serialize :tunings

  before_create :set_default_publish_times

  def self.instance
    first_or_create!
  end

  def within_publish_window?
    current_time = only_time(Time.now.utc)
    publish_start_time_utc = only_time(publish_start_time.utc)
    publish_end_time_utc = only_time(publish_end_time.utc)

    if publish_start_time_utc < publish_end_time_utc
      current_time >= publish_start_time_utc && current_time <= publish_end_time_utc
    else
      current_time >= publish_start_time_utc || current_time <= publish_end_time_utc
    end
  end

  private

  def set_default_publish_times
    self.publish_start_time ||= Time.zone.parse('08:00')
    self.publish_end_time ||= Time.zone.parse('20:00')
  end

  def only_time(time)
    Time.new(2000, 1, 1, time.hour, time.min, time.sec, time.utc_offset)
  end
end

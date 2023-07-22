# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  topics     :text
#  prompts    :text
#  tunings    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Setting < ApplicationRecord
  def self.instance
    first_or_create!
  end
end

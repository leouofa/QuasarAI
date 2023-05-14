# == Schema Information
#
# Table name: locks
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  locked     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Lock < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end

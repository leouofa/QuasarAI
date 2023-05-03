class Story < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :feed_items, through: :assignments
end

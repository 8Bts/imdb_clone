class Category < ApplicationRecord
  extend FriendlyId
  has_and_belongs_to_many :movies
  
  friendly_id :name, use: [:slugged, :finders]
  validates :name, presence: true, uniqueness: true, length: { in: 2..32 }
end

class Category < ApplicationRecord
  has_and_belongs_to_many :movies

  validates :name, presence: true, uniqueness: true, length: { in: 2..32 }
end

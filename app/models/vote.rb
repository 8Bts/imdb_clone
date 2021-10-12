class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end

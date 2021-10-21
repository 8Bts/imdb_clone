class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :movie_id, uniqueness: { scope: :user_id }
  validates :rating, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end

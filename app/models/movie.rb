class Movie < ApplicationRecord
  has_many :votes
  has_and_belongs_to_many :categories

  validates :title, presence: true, uniqueness: true, length: { in: 1..64 }
  validates :description, presence: true, length: { in: 10..255 }
  validates :image, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

  def rating
    sum = votes.sum(:rating)
    votes_count = votes.count

    if votes_count.positive?
      (sum / votes_count).ceil(1)
    else
      0
    end
  end
end

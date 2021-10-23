class Movie < ApplicationRecord
  has_many :votes
  has_and_belongs_to_many :categories

  mount_uploader :image, MoviePosterUploader

  validates :title, presence: true, uniqueness: true, length: { in: 1..64 }
  validates :description, presence: true, length: { in: 10..255 }
  validates :image, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

  def rating
    sum = votes.sum(:rating)
    votes_count = votes.count
    result = nil

    if votes_count.positive?
      result = (sum.to_f / votes_count).ceil(1)
      return result if result != 10
      10 
    else
      0
    end
  end
end

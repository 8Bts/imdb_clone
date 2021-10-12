class Movie < ApplicationRecord
  has_many :votes
  has_and_belongs_to_many :categories

  validates :title, presence: true, uniqueness: true, length: { in: 1..32 }
  validates :description, presence: true, uniqueness: true, length: { in: 10..255 }
  validates :image, presence: true, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
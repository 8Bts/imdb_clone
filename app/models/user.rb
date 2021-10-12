class User < ApplicationRecord
  has_secure_password

  has_many :votes

  validates :name, presence: true, uniqueness: true, length: { in: 3..12 }
  validates :admin_level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Invalid email format' }
  validates :password_digest, presence: true
end

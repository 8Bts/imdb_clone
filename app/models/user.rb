class User < ApplicationRecord
  before_save :default_values
  has_secure_password

  has_many :votes

  validates :name, presence: true, uniqueness: true, length: { in: 3..12 }
  validates :admin_level, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'is invalid' }
  validates :password, length: { in: 8..ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED }

  def default_values
    self.admin_level = 0  if self.admin_level.nil?
  end
end

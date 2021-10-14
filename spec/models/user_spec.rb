require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create :user }

  it { should have_secure_password }

  # Association test
  it { should have_many(:votes) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(12) }

  it { should validate_numericality_of(:admin_level).only_integer }
  it { should validate_numericality_of(:admin_level).is_less_than_or_equal_to(3) }
  it { should validate_numericality_of(:admin_level).is_greater_than_or_equal_to(0) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('foo@bar.com').for(:email).with_message('Invalid email format') }
  it { should_not allow_value('foo').for(:email) }
end

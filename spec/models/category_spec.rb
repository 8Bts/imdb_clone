require 'rails_helper'

RSpec.describe Category, type: :model do
  # Association test
  it { should have_and_belong_to_many(:movies) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_length_of(:name).is_at_least(2).is_at_most(32) }
end

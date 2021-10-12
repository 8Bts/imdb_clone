require 'rails_helper'

RSpec.describe Vote, type: :model do
  # Association test
  it { should belong_to(:movies) }
  it { should belong_to(:users) }

  # Validation tests
  it { should validate_presence_of(:rating) }
  it { should validate_numericality_of(:rating).is_less_than_or_equal_to(10)}
  it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0)}
end

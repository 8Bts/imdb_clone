require 'rails_helper'

RSpec.describe Movie, type: :model do
  # Association test
  it { should have_and_belong_to_many(:categories) }
  it { should have_many(:votes) }

  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it { should validate_length_of(:title).is_at_least(1).is_at_most(64) }

  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_least(10).is_at_most(255) }

  it { should validate_presence_of(:image) }
end

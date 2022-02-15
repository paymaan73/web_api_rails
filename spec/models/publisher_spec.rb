require 'rails_helper'

RSpec.describe Publisher, type: :model do
  it { should validate_presence_of(:name) }

  it 'has a valid factory' do
    expect(build(:publisher)).to be_valid
  end
end

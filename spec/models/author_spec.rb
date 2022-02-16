require 'rails_helper'

RSpec.describe Author, type: :model do
  it { should validate_presence_of(:given_name) }
  it { should validate_presence_of(:family_name) }

  # An author should indeed have many books!
  it { should have_many(:books) }

  it 'has a valid factory' do
    expect(build(:author)).to be_valid
  end
end

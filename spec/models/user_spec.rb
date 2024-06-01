require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'is valid with a first name, last name, email, and password' do
    user = User.new(
      first_name: 'Aaron',
      last_name: 'Sumner',
      email: 'tester@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze',
    )
    expect(user).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of :first_name }

    it { should validate_presence_of :last_name }

    it { should validate_presence_of :email }

    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.name).to eq 'John Doe'
  end
end

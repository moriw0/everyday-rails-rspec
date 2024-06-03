require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
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

    it { should validate_presence_of :first_name }

    it { should validate_presence_of :last_name }

    it { should validate_presence_of :email }

    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should have_many(:projects).dependent :destroy }

    it { should have_many(:notes).dependent :destroy }
  end

  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.name).to eq 'John Doe'
  end

  # ユーザー作成時にコールバックで以下メソッドが呼び出されることを検証
  # def send_welcome_email
  #   UserMailer.welcome_email(self).deliver_later
  # end
  it 'sends a welcome email on account creation' do
    # メソッドチェーンを許可する
    allow(UserMailer).to \
      receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    # ユーザー作成時に既に実行したことを検証
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  it 'performs geododing', vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: '161.185.207.20')
    expect {
      user.geocode
  }.to change(user, :location).
    from(nil).
    to('New York City, New York, US')
  end
end

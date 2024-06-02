require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  describe 'validations' do
    it 'is valid with a user, project, and message' do
      note = Note.new(
        message: 'This is a simple note.',
        user: user,
        project: project
      )
      expect(note).to be_valid
    end

    it { should belong_to :project }

    it { should belong_to :user }

    it { should validate_presence_of :message }

    it { should have_one_attached :attachment }
  end

  describe 'search message for a term' do
    let!(:note1) { FactoryBot.create(:note,
      project: project,
      message: 'This is the first note.',
      user: user
    ) }

    let!(:note2) { FactoryBot.create(:note,
      project: project,
      message: 'This is the second note.',
      user: user
    ) }

    let!(:note3) { FactoryBot.create(:note,
      project: project,
      message: 'First, preheat the oven.',
      user: user
    ) }

    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(note1, note3)
        expect(Note.search('first')).to_not include(note2)
      end
    end

    context 'when no match is found' do
      it 'returns an empty collection when no results are found' do
        expect(Note.search('message')).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end

  it 'delegates name to the user who created it' do
    # テストダブルでnameという属性を与えている
    # Userモデルではfirst_name + last_nameを返すnameメソッド
    # user = double('user', name: 'Fake User')
    user = instance_double('User', name: 'Fake User')
    note = Note.new
    # スタブによってnoteにuserダブルを教え込んでいる
    allow(note).to receive(:user).and_return(user)
    # noteはdelegateされたuser_name(name)を使用可能になる
    # noteのuser_idを使ってデータベースにアクセスすることはない
    expect(note.user_name).to eq 'Fake User'
  end
end

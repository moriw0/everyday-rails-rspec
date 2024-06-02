require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

    it { should belong_to(:owner).class_name 'User' }

    it { should have_many(:notes).dependent :destroy }

    it { should have_many(:tasks).dependent :destroy }
  end

  describe 'late status' do
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :project_due_yesterday)
      expect(project).to be_late
    end

    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :project_due_today)
      expect(project).to_not be_late
    end

    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :project_due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it 'can have many notes' do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end

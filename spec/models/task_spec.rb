require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { FactoryBot.create(:project) }

  describe 'validations' do
    it 'is valid with a project and name' do
      task = Task.new(
        project: project,
        name: 'Test Task'
      )
      expect(task).to be_valid
    end

    it { should belong_to :project }

    it { should validate_presence_of :name }
  end
end

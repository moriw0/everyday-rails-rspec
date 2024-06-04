require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe '#index' do
    let!(:completed_project) {
      FactoryBot.create(:project,
        name: 'Completed Project',
        owner: user,
        completed: true)
    }
    let!(:on_going_project) {
      FactoryBot.create(:project,
        name: 'On Going Project',
        owner: user,
        completed: false)
    }

    it 'shows only on going projects' do
      sign_in_and_vist_root_path(user)

      visit projects_path

      expect(page).to have_content 'On Going Project'
      expect(page).to_not have_content 'Completed Project'
    end

    it 'switches showing projects' do
      sign_in_and_vist_root_path(user)

      visit projects_path

      expect(page).to_not have_content 'Completed Project'
      expect(page).to have_content 'On Going Project'

      expect(page).to_not have_link 'Show Only On going Projects'
      click_link 'Show All Projects'

      expect(page).to have_content 'Completed Project'
      expect(page).to have_content 'On Going Project'

      expect(page).to_not have_link 'Show All Projects'
      click_link 'Show Only On going Projects'

      expect(page).to_not have_content 'Completed Project'
      expect(page).to have_content 'On Going Project'
    end
  end

  describe '#new' do
    scenario 'user creates a new project' do
      sign_in_and_vist_root_path(user)

      expect {
        click_link 'New Project'
        fill_in 'Name', with: 'Test Project'
        fill_in 'Description', with: 'Trying out Capybara'
        click_button 'Create Project'
      }.to change(user.projects, :count).by 1

      aggregate_failures do
        expect(page).to have_content 'Project was successfully created'
        expect(page).to have_content 'Test Project'
        expect(page).to have_content "Owner: #{user.name}"
      end
    end
  end

  describe '#edit' do
    let!(:project) {
      FactoryBot.create(:project,
        name: 'First Project',
        description: 'first step',
        owner: user)
    }

    scenario 'user edits the project' do
      sign_in_and_vist_root_path(user)

      click_link 'First Project'
      click_link 'Edit'

      fill_in 'Description', with: 'final step'
      click_button 'Update Project'

      expect(page).to have_content 'Project was successfully updated.'
      expect(page).to have_content 'final step'
    end
  end

  describe '#complete' do
    let!(:project) {
      FactoryBot.create(:project,
        name: 'First Project',
        owner: user)
    }

    scenario 'user completes a project' do
      sign_in_and_vist_root_path(user)

      visit project_path(project)
      expect(page).to_not have_content "Completed"
      click_button "Complete"
      expect(project.reload.completed?).to be true
      expect(page).to \
      have_content "Congratulations, this project is complete!"
      expect(page).to have_content "Completed"
      expect(page).to_not have_button "Complete"
    end
  end

  def sign_in_and_vist_root_path(user)
    sign_in user
    visit root_path
  end
end

require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'does not allow duplicate project names per user' do
    user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'joetester@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze',
    )

    user.projects.create(
      name: 'Test project'
    )

    new_project = user.projects.build(
      name: 'Test project'
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  it 'allows two users to share a project name' do
    user = User.create(
      first_name: 'Joe',
      last_name: 'Tester',
      email: 'joetester@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze',
    )

    user.projects.create(
      name: 'Test project'
    )

    other_user = User.create(
      first_name: 'Jane',
      last_name: 'Tester',
      email: 'janetester@example.com',
      password: 'dottle-nouveau-pavilion-tights-furze',
    )

    other_project = other_user.projects.build(
      name: 'Test project'
    )

    expect(other_project).to be_valid
  end
end

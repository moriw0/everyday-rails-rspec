FactoryBot.define do
  factory :note do
    message { 'My inportant note.'}
    association :project
    user { project.owner }
  end
end

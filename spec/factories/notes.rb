FactoryBot.define do
  factory :note do
    message { 'My inportant note.'}
    association :project
    user { project.owner }

    trait :with_attachment do
      attachment { Rack::Test::UploadedFile.new( \
        "#{Rails.root}/spec/files/attachment.png", 'image/png') }
    end
  end
end

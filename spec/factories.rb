FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password {'secretPassword'}
    password_confirmation {'secretPassword'}
  end

  factory :gram do
    message {'Hello'}
    image {fixture_file_upload(Rails.root.join('spec', 'fixtures', 'image.png').to_s, 'image/png')}
    association :user
  end
end
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    age { Faker::Number.number(digits: 2) }
    gender { Faker::Gender.type }
    confirmed_at { Time.current }
  end
end

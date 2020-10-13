FactoryBot.define do
  factory :category do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    user
  end
end

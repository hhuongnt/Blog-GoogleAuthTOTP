FactoryBot.define do
  factory :rate do
    value { Faker::Number.number(digits: 1) }
    user
    post
  end
end

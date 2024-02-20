FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    name { Faker::Internet.name }
    phone { Faker::Number.number(digits: 10) }
    after(:create) { |user| user.add_role(:seller) }
  end
end

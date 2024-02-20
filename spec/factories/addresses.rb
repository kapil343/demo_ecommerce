FactoryBot.define do
  factory :address do
    state { "MP" }
    city { "Indore" }
    pincode { 123456 }
    association :user
  end
end

FactoryBot.define do
  factory :discount do
    percentage { 10 }
    expiry_date { 20.days.from_now }
    association :product
  end
end

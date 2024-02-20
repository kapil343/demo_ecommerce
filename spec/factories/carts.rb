FactoryBot.define do
  factory :cart do
    total_amount { 0.0 }
    association :user
  end
end

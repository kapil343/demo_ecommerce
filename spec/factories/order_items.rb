FactoryBot.define do
  factory :order_item do
    association :product
    association :cart
    association :order
  end
end

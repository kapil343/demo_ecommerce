FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price { 100 }
    description { "Product description" }
    brand { "Brand" }
    stock_quantity { 10 }
    association :user
    association :category

  end
end

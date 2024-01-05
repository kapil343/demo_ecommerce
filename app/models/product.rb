class Product < ApplicationRecord
  has_one_attached :product_image
  belongs_to :user
  belongs_to :category
  has_many :discounts
end

class Product < ApplicationRecord
  paginates_per 5

  has_one_attached :product_image
  belongs_to :user
  belongs_to :category
  has_one :discount

  def discounted_price product
    discount = product.discount
      if discount
        product.price - (product.price * discount.percentage / 100)
      else
        product.price
      end
  end
end

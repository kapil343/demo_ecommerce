class Product < ApplicationRecord
  paginates_per 5

  has_one_attached :product_image
  belongs_to :user
  belongs_to :category
  has_one :discount
  has_many :reviews

  def discounted_price product
    discount = product.discount
      if discount
        product.price - (product.price * discount.percentage / 100)
      else
        product.price
      end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "category_id", "created_at", "description", "id", "id_value", "name", "price", "stock_quantity", "updated_at", "user_id"]
  end
end

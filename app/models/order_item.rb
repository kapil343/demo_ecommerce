class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  validates :quantity, :product_id, :order_id, :cart_id, presence: true

end

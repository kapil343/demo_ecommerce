class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, :product_id, :cart_id, presence: true

  def remove_from_cart(cart_item)
    old_quantity = cart_item.quantity
    cart_item.destroy

    cart = cart_item.cart
    cart.total_amount -= (cart_item.product.discounted_price(cart_item.product) * old_quantity)
    cart.save

    true
  end
end

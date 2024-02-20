class Order < ApplicationRecord
  paginates_per 10

  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  enum status: %i[complete pending canceled]

  validates :order_date, :status, :total_amount, :user_id, presence: true, on: :update

  def create_order_from_cart(order, cart, user)

    order.update(
      order_date: Time.now,
      total_amount: (order.total_amount || 0) + cart.total_amount,
      status: :pending,
    )

    cart.cart_items.each do |cart_item|
      order_item = order.order_items.build(
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        cart_id: cart.id
      )
      order_item.save

      product = Product.find(cart_item.product_id)
      product.update(stock_quantity: product.stock_quantity - cart_item.quantity)

      cart_item.destroy
    end

    order
  end
end

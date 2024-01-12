class OrderItemsController < ApplicationController
  def index
    @order_items = OrderItem.all
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    @order_item.save
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id, :cart_id)
  end
end

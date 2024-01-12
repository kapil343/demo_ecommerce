class OrdersController < ApplicationController
  def index
    if current_user.has_role? :admin
      @orders = Order.all.order(:created_at)
    else
      @orders = current_user.orders.all.order(:created_at)
    end
  end

  def new
    @order = current_user.orders.build
  end

  def create
    @order = current_order
    @order.update(order_params)

    last_address = current_user.addresses.last
    @order.update(
      order_date: Time.now,
      total_amount: current_order.total_amount + current_cart.total_amount,
      status: 'pending',
      # address: "#{current_user.addresses.last.state}, #{current_user.addresses.last.city}, #{current_user.addresses.last.pincode}")
      address: "#{last_address.state}, #{last_address.city}, #{last_address.pincode}"
    )

    if @order.save
      current_cart.cart_items.each do |cart_item|
        order_item = @order.order_items.build(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          cart_id: current_cart.id
        )
        order_item.save

        product = Product.find(cart_item.product_id)
        product.update(stock_quantity: product.stock_quantity - cart_item.quantity)

        cart_item.destroy
      end
      current_cart.total_amount=0
      current_cart.save
      redirect_to user_orders_path(current_user)
    else
      redirect_to root_path, alert: 'Failed to create order'
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to root_path
  end

  private

  def order_params
    params.require(:order).permit(:payment, :user_id)
  end
end

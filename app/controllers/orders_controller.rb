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
        total_amount: (current_order.total_amount || 0) + current_cart.total_amount,
        status: :pending,
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
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "invoice",
          template: 'orders/order',
          formats: [:html],
          layout: 'invoice',
          disposition: 'attachment'   # Excluding ".pdf" extension.
      end
    end
  end

  def update
      @order = Order.find(params[:id])
        if @order.update(order_params)
          redirect_to @order, notice: 'Order status was successfully updated.'
        else
          render :edit
        end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to root_path
  end

  def bulk_update
    Order.where(id: params[:order_ids]).update_all(status: params[:status])
    redirect_to orders_path, notice: 'Bulk update successful.'
  end

  def cancel
    @order = Order.find(params[:id])
      if @order.update(status: 'canceled')
        redirect_to user_order_path(current_user, @order), notice: 'Order was successfully canceled.'
      else
        redirect_to user_order_path(current_user, @order), alert: 'Failed to cancel the order.'
      end
  end

  private

  def order_params
    params.require(:order).permit(:address, :payment, :user_id, :status)
  end
end

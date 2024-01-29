class OrdersController < ApplicationController
  before_action :set_order,only: [:show, :update, :destroy, :cancel]

  def index
    @orders = current_user.has_role?(:admin) ? Order.all.order(:created_at).page(params[:page]) : current_user.orders.all.order(:created_at).page(params[:page])
  end

  def new
    @order = current_user.orders.build
  end

  def create
    current_order.update(order_params).save
    @order = current_order.create_order_from_cart(current_order, current_cart, current_user)

    if @order.save
      current_cart.total_amount = 0
      current_cart.save

      redirect_to user_orders_path(current_user)
      OrderMailer.place_order_notification(@order).deliver_now
    else
      redirect_to root_path, alert: 'Failed to create order'
    end
  end

  def show
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
    if @order.update(order_params)
      redirect_to @order, notice: 'Order status was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to root_path
  end

  def bulk_update
    Order.where(id: params[:order_ids]).update_all(status: params[:status])
    redirect_to orders_path, notice: 'Bulk update successful.'
  end

  def cancel
    if @order.status=='complete'
      redirect_to user_orders_path, alert: 'you cannot cancel the order'
    else
      if @order.update(status: 'canceled')
      redirect_to user_order_path(current_user, @order), notice: 'Order was successfully canceled.'
      else
        redirect_to user_order_path(current_user, @order), alert: 'Failed to cancel the order.'
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:address, :payment, :user_id, :status)
  end

  def set_order
    @order = Order.find_by(id: params[:id])
  end
end

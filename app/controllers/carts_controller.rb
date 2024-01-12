class CartsController < ApplicationController
  def show
    @cart = current_cart
  end
  def destroy
    @cart = current_user.cart
    @cart.cart_items.destroy_all
    @cart.total_amount = 0
    @cart.save

    session[:cart_id] = nil
    redirect_to root_path
  end
end

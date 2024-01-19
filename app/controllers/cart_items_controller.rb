class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:update, :destroy]
  def create
    product = Product.find(params[:product_id])
    # you can use this one also as alternative if this doesn't work cart = current_user.cart
    cart = current_cart

    # Check if the product already exists in the cart
    if !cart.nil?
      cart_item = cart.cart_items.find_by(product_id: product.id)
    end
    if product.stock_quantity > 0
      if cart_item
        # If the product already exists, increment the quantity
        cart_item.quantity += 1
      else
        # If the product doesn't exist, create a new cart item
        cart_item = cart.cart_items.build(product: product)
      end

      if cart_item.save
        cart.reload # Reload the cart to get the updated cart_items association
        cart.total_amount = cart.cart_items.sum { |item| item.product.price * item.quantity }
        cart.save

        redirect_to cart_path, notice: 'Product added to cart successfully!'
      else
        redirect_to product_path(product), alert: 'Failed to add product to cart.'
      end
    else
      redirect_to product_path(product), alert: 'Product is out of stock.'
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    old_quantity = @cart_item.quantity

    # Update quantity of the cart item
    if params[:cart_item] [:change] == 'increase'
      if @cart_item.quantity < @cart_item.product.stock_quantity
        @cart_item.quantity += 1
      else
        redirect_to cart_path, alert: "Only #{@cart_item.product.quantity} available in stock."
        return
      end
    elsif params[:cart_item] [:change] == 'decrease' && @cart_item.quantity > 1
      @cart_item.quantity -= 1
    else
      redirect_to cart_path, alert: 'Invalid quantity change request.'
      return
    end

    if @cart_item.save
      # Update total_amount based on the quantity change
    cart = current_user.cart
    cart.total_amount += (@cart_item.product.price * (@cart_item.quantity - old_quantity))
    cart.save

      redirect_to cart_path, notice: 'Cart item quantity updated successfully!'
    else
      redirect_to cart_path, alert: 'Failed to update cart item quantity.'
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    old_quantity = @cart_item.quantity
    @cart_item.destroy
    # Update total_amount based on the deleted item
    cart = current_user.cart
    cart.total_amount -= (@cart_item.product.price * old_quantity)
    cart.save
    redirect_to user_cart_path(current_cart)
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def set_cart_item
    @cart_item = current_user.cart.cart_items.find(params[:id])
  end
end

class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:update, :destroy]

  def create
    if user_signed_in?
      product = Product.find(params[:product_id])
      # you can use this one also as alternative if this doesn't work cart = current_user.cart
      cart = current_cart
      cart_item = find_or_initialize_cart_item(cart, product)
      if cart_item.save
        update_cart_total_amount(cart)
        redirect_to cart_path, notice: 'Product added to cart successfully!'
      else
        redirect_to product_path(product), alert: 'Failed to add product to cart.'
      end
    else
      redirect_to root_path, alert: 'Please sign in to continue'
    end
  end

  def update
    old_quantity = @cart_item.quantity
    # Update quantity of the cart item
    @cart_item = update_cart_item_quantity(@cart_item)
    if @cart_item.save
      # Update total_amount based on the quantity change
      cart = current_user.cart
      cart.total_amount += (@cart_item.product.discounted_price(@cart_item.product) * (@cart_item.quantity - old_quantity))
      cart.save
      redirect_to cart_path, notice: 'Cart item quantity updated successfully!'
    else
      redirect_to cart_path, alert: 'Failed to update cart item quantity.'
    end
  end

  def destroy
    success = @cart_item.remove_from_cart(@cart_item)
    if success
      redirect_to user_cart_path(current_cart), notice: 'Cart item removed successfully!'
    else
      redirect_to cart_path, alert: 'Failed to remove cart item.'
    end
  end

  private

    def set_cart_item
      @cart_item = current_user.cart.cart_items.find(params[:id])
    end

    def find_or_initialize_cart_item(cart, product)
      #Check if the product already exists in the cart
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
      else
        redirect_to product_path(product), alert: 'Product is out of stock.'
      end
      cart_item
    end

    def update_cart_total_amount(cart)
      cart.reload
      cart.total_amount = cart.cart_items.sum { |item| item.product.discounted_price(item.product) * item.quantity }
      cart.save
    end

    def update_cart_item_quantity(cart_item)
      if params[:cart_item] [:change] == 'increase'
        if cart_item.quantity < cart_item.product.stock_quantity
          cart_item.quantity += 1
        else
          redirect_to cart_path, alert: "Only #{cart_item.product.stock_quantity} available in stock."
          return
        end
      elsif params[:cart_item] [:change] == 'decrease' && cart_item.quantity > 1
        cart_item.quantity -= 1
      else
        redirect_to cart_path, alert: 'Invalid quantity change request.'
        return
      end
      cart_item
    end

end

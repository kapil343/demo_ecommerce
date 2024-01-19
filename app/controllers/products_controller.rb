class ProductsController < ApplicationController
  def index
    if current_user and current_user.has_role? :seller
      @products = current_user.products.page(params[:page])
    elsif params[:category_id]
      @products = Product.where(category_id: params[:category_id]).page(params[:page])
    else
      @products = Product.all.page(params[:page])
    end
  end

  def new

  end

  def create
    @user = User.find(params[:user_id])
    @product = @user.products.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end
  def edit
    if current_user.has_role? :seller
          @product = current_user.products.find(params[:id])
    else
      @product = Product.find(params[:id])
    end
  end
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:product_image, :name, :price, :description, :brand, :stock_quantity, :category_id)
  end
end

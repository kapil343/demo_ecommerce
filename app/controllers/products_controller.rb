class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create]
  # before_action :authenticate_member!

  def index
    @products = if current_user&.has_role?(:seller)
                  @q = current_user.products.ransack(params[:q])
                  @q.result(distinct: true).page(params[:page])
                elsif params[:category_id]
                  @q = Product.where(category_id: params[:category_id]).ransack(params[:q])
                  @q.result(distinct: true).page(params[:page])
                else
                  @q = Product.ransack(params[:q])
                  @q.result(distinct: true).page(params[:page])
                end

    respond_to do |format|
      format.html
      format.csv { send_data Product.to_csv, filename: "products.csv"}
    end
  end

  def new
    @product = current_user.products.build
  end

  def create
    product = @user.products.new(product_params)
    if product.save
      # redirect_to products_path
      redirect_to product
    else
      render :new
    end
  end

  def show
  end

  def edit
    ensure_authorized_seller
  end

  def update
    ensure_authorized_seller
    if @product.update(product_params)
      # redirect_to product_path(@product)
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    ensure_authorized_seller
    @product.destroy
    redirect_to products_path
  end

  def import
    if Product.import(params[:file])
      redirect_to root_url, notice: "Products imported successfully"
    else
      redirect_to root_url, alert: "Error importing products"
    end
  end

  private

    def product_params
      params.require(:product).permit(:product_image, :name, :price, :description, :brand, :stock_quantity, :category_id)
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def ensure_authorized_seller
      redirect_to root_path unless (current_user&.has_role?(:seller) && current_user.products.exists?(params[:id])) || current_user&.has_role?(:admin)
    end

end

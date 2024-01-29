class DiscountsController < ApplicationController
  before_action :set_discount, only: [:edit, :update, :destroy]

  def index
    @discounts = Discount.all.page(params[:page])
  end

  def new
    @discount = Discount.new
  end

  def create
    discount = Discount.new(discount_params)
    if discount.save
      redirect_to discounts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @discount.update(discount_params)
      redirect_to discounts_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @discount.destroy
    redirect_to discounts_path
  end

  private

    def discount_params
      params.require(:discount).permit(:percentage, :expiry_date, :product_id)
    end

    def set_discount
      @discount = Discount.find(params[:id])
    end

end

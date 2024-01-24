class DiscountsController < ApplicationController
  def index
  @discounts = Discount.all.page(params[:page])
    end
    def new
      @discount = Discount.new
    end
    def create
      @discount = Discount.new(discount_params)
      if @discount.save
        redirect_to discounts_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @discount = Discount.find(params[:id])
    end
    def update
      @discount = Discount.find(params[:id])
      if @discount.update(discount_params)
        redirect_to discounts_path
      else
        render :edit, status: :unprocessable_entity
      end
    end
    def destroy
      @discount = Discount.find(params[:id])
      @discount.destroy
      redirect_to discounts_path
    end

    private
    def discount_params
      params.require(:discount).permit(:percentage, :expiry_date, :product_id)
  end
end

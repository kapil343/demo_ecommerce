class ReviewsController < ApplicationController
  before_action :set_product
  before_action :set_review, only: [:edit, :update, :destroy]

  def new
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'Review was successfully created.'
    else
      flash.now[:alert] = 'Failed to create review.'
      render 'products/show'
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @product, notice: 'Review was successfully updated.'
    else
      flash.now[:alert] = 'Failed to update review.'
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to @product, notice: 'Review was successfully deleted.'
  end

  private

    def review_params
      params.require(:review).permit(:rating, :comment)
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_review
      @review = @product.reviews.find(params[:id])
    end
end

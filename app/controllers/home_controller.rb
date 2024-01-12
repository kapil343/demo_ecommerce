class HomeController < ApplicationController
  def index
    @products = Product.all.page(params[:page])
    # render template: 'products/index'
  end
end

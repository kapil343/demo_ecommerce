class HomeController < ApplicationController
  def index
    @products = Product.all
    # render template: 'products/index'
  end
end

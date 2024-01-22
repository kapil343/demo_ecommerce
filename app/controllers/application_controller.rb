class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone])
  end

  def current_cart
    return if current_user.blank?
    @current_cart ||= current_user.ensure_cart
  end
  helper_method :current_cart

  def current_order
    order = Order.where(user_id: current_user.id).last
    return Order.create(user_id: current_user.id) if order.nil?

    order.status == 'complete' ? Order.create(user_id: current_user.id) : order
    order.status == 'canceled' ? Order.create(user_id: current_user.id) : order
  end
end

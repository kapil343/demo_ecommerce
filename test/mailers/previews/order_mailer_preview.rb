# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/place_order_notification
  def place_order_notification
    OrderMailer.place_order_notification
  end

end

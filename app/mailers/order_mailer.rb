class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.place_order_notification.subject
  
  def place_order_notification order
    @order = order
    pdf_data = render_to_string(
      pdf: "invoice",
      template: 'orders/order',
      formats: [:html],
      layout: 'invoice',
      disposition: 'attachment',
      locals: { order: @order } # Pass order data to the template
    )
    # Attach the PDF to the email
    attachments["invoice.pdf"] = {
      mime_type: 'application/pdf',
      content: pdf_data
    }
    mail to: @order.user.email, subject: "order placed"
  end

end

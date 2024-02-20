class WeeklyDiscountMailer < ApplicationMailer
  def discount_email(user, discounts)
    @user = user
    @discounts = discounts
    mail(to: @user.email, subject: 'Weekly Discounts on Products')
  end
end

class WeeklyDiscountJob
  include Sidekiq::Job

  def perform
    discounts = Discount.where("percentage > ?", 15)
    User.find_each do |user|
      WeeklyDiscountMailer.discount_email(user, discounts).deliver_now
    end
  end
end

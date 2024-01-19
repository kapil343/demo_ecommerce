class Discount < ApplicationRecord
  belongs_to :product
  paginates_per 5
  validate :unique_discount_for_product

  private

  def unique_discount_for_product
    if product&.discount.present?
      errors.add(:product_id, 'already has a discount')
    end
  end
end

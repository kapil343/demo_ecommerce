class Discount < ApplicationRecord
  belongs_to :product
  paginates_per 5

  validates :percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :expiry_date, presence: true
  validate :unique_discount_for_product

  def unique_discount_for_product
    if persisted? && product&.discount.present? && product.discount.percentage > 0
      errors.add(:product_id, 'already has a discount')
    end
  end
end

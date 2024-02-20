class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  # has_many :order_items, dependent: :destroy
  belongs_to :user

  validates :total_amount, :user_id, presence: true

end

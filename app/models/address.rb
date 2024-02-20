class Address < ApplicationRecord
  belongs_to :user

  validates :state, :city, presence: true
  validates :pincode, presence: true, numericality: { only_integer: true }
  validates :user_id, presence: true
end

class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :phone, presence: true, format: { with: /\A\d{10}\z/, message: "should be 10 digits" }

  has_many :products
  has_many :addresses
  has_one :cart
  has_many :orders
  has_many :addresses
  has_many :wishlists, dependent: :destroy
  accepts_nested_attributes_for :addresses

  def assign_default_role
    self.add_role(:customer) if self.roles.blank?
  end

  def ensure_cart
    cart.presence || create_cart
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end

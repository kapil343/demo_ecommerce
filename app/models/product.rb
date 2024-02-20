class Product < ApplicationRecord
  require 'csv'
  paginates_per 5

  has_one_attached :product_image
  belongs_to :user
  belongs_to :category
  has_one :discount
  has_many :reviews

  validates :name, :price, :description, :brand, :stock_quantity, :user_id, :category_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def discounted_price product
    discount = product.discount
      if discount
        product.price - (product.price * discount.percentage / 100)
      else
        product.price
      end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "category_id", "created_at", "description", "id", "id_value", "name", "price", "stock_quantity", "updated_at", "user_id"]
  end

  def self.to_csv
    products = all
    CSV.generate do |csv|
      csv << column_names
      products.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      product = new
      product.attributes = row.to_hash
      product.save!
    end
  end

end

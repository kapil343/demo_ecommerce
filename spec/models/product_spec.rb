require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "associations" do
    it { should have_one_attached :product_image }
    it { should belong_to :user }
    it { should belong_to :category }
    it { should have_one :discount }
    it { should have_many :reviews }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:stock_quantity) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:category_id) }
  end

  describe "discounted_price" do
    it "returns the discounted price if discount is available" do
      product = create(:product, price: 100)
      discount = Discount.create(product_id: product.id, percentage: 10)
      expect(product.discounted_price(product)).to eq(90)
    end

    it "returns the original price if no discount is available" do
      product = create(:product, price: 100, discount: nil)
      expect(product.discounted_price(product)).to eq(100)
    end
  end

  describe ".to_csv" do
    it "returns a CSV file with product attributes" do
      product = create(:product)
      csv_data = Product.to_csv
      expect(csv_data).to include(product.name)
      expect(csv_data).to include(product.price.to_s)
      expect(csv_data).to include(product.description)
      expect(csv_data).to include(product.brand)
      expect(csv_data).to include(product.stock_quantity.to_s)
    end
  end

end

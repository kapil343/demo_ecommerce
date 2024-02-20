require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "associations" do
    it { should belong_to(:product) }
  end

  describe "validations" do
    it { should validate_presence_of(:percentage) }
    it { should validate_numericality_of(:percentage).is_greater_than_or_equal_to(0) }
  end

  describe "custom validation for unique discount " do
    let(:product) { create(:product) }

    it "should allow saving a discount if no other discount exists for the product" do
      discount = build(:discount, product_id: product.id)
      expect(discount).to be_valid
    end

    it "should not allow saving a discount if another discount exists for the product" do
      discount = create(:discount, product_id: product.id)
      expect(discount).not_to be_valid
    end
  end
end

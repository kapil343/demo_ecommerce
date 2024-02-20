require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe "associations" do
    it { should belong_to(:product) }
    it { should belong_to(:cart) }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:cart_id) }
  end

  describe "#remove_from_cart" do
    let(:product) { create(:product, price: 100) }
    let(:user) { create :user }
    let(:cart) { create(:cart, user_id: user.id) }
    let(:cart_item) { create(:cart_item, product_id: product.id, cart_id: cart.id) }

    it "removes the cart item from the cart and updates the total amount" do
      expect {
        cart_item.remove_from_cart(cart_item)
      }.to change { CartItem.exists?(cart_item.id) }.from(true).to(false)

      expect(cart.total_amount).to eq(0)
    end
  end
end

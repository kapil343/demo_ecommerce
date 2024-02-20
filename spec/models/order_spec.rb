require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
    it { should have_many(:products).through(:order_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:order_date).on(:update) }
    it { should validate_presence_of(:status).on(:update) }
    it { should validate_presence_of(:total_amount).on(:update) }
    it { should validate_presence_of(:user_id).on(:update) }
  end

  describe "#create_order_from_cart" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:address) { create(:address, user: user) }
    let(:category) { create(:category ) }
    let(:product) { create(:product, user: user2, category: category) }
    let(:cart) { create(:cart, user: user) }
    let(:cart_item) { create(:cart_item, cart: cart, product: product) }
    let(:order) { create(:order, user: user) }

    it "creates an order from the cart" do
      initial_cart_items_count = cart.cart_items.count

      expect {
        order.create_order_from_cart(order, cart, user)
      }.to change(Order, :count).by(1)

      expect(order.total_amount).to eq(cart.total_amount)
      expect(order.status).to eq("pending")
      expect(order.order_items.count).to eq(initial_cart_items_count)
    end
  end
end

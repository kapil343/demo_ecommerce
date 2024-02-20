require 'rails_helper'

RSpec.describe User, type: :model do
  context "when creating a user" do
    let(:user) { build :user }
    let(:user1) { create :user }

    it "should be valid user with all attributes" do
      expect(user.valid?)
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    describe "callbacks" do
      it "should have role assigned if no role is assigned" do
        expect(user1.roles.exists? == true)
      end

      it "sends welcome email after create" do
        allow(UserMailer).to receive(:welcome_email).and_return(double(deliver_now: true))
      end

      it "creates a cart if it doesn't exist" do
        user1.ensure_cart
        user1.cart.destroy
        user1.ensure_cart
        expect(user1.cart).to be_present
      end

      it "returns existing cart if it already exists" do
        cart = user1.ensure_cart
        expect(user1.ensure_cart).to eq(cart)
      end
    end
  end

  describe "validations" do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should allow_value("1234567890").for(:phone) }
    it { should_not allow_value("12345").for(:phone) }
  end

  describe "associations" do
    it { should have_many(:products) }
    it { should have_one(:cart) }
    it { should have_many(:orders) }
    it { should have_many(:addresses) }
    # it { should have_many(:wishlists).dependent(:destroy) }
  end

end

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "associations" do
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:products).through(:cart_items) }
    # it { should have_many(:order_items).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:total_amount) }
    it { should validate_presence_of(:user_id) }
  end
end

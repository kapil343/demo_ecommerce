require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "associations" do
    it { should belong_to(:product) }
    it { should belong_to(:cart) }
    it { should belong_to(:order) }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:order_id) }
    it { should validate_presence_of(:cart_id) }
  end
end

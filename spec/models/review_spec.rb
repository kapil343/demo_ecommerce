require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "associations" do
    it { should belong_to(:product) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:rating) }
    it { should validate_numericality_of(:rating).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
    it { should validate_presence_of(:comment) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:product_id) }
  end
end

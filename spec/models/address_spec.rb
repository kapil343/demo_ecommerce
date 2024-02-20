require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:pincode) }
    it { should validate_numericality_of(:pincode).only_integer }
    it { should validate_presence_of(:user_id) }
  end
end

class CreateDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :discounts do |t|
      t.float :percentage
      t.datetime :expiry_date
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.float :total_amount, default: 0.0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

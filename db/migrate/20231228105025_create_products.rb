class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.text :description
      t.string :brand
      t.integer :stock_quantity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

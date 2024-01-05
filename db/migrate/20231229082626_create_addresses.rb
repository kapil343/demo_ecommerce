class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :state
      t.string :city
      t.integer :pincode, limit: 6
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

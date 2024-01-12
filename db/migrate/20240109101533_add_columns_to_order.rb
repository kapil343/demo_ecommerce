class AddColumnsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment, :integer
    add_column :orders, :address, :string
  end
end

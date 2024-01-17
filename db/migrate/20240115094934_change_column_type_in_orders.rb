class ChangeColumnTypeInOrders < ActiveRecord::Migration[7.1]
  def up
    change_column :orders, :status, 'integer USING CAST(status AS integer)'
  end

  def down
    change_column :orders, :status, :string
  end
end

class RemoveRefCartFromOrderItem < ActiveRecord::Migration[7.1]
  def change
    remove_reference :order_items, :cart, null: false, foreign_key: true
  end
end

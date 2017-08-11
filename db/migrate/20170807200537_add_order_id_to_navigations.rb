class AddOrderIdToNavigations < ActiveRecord::Migration[5.1]
  def change
    add_column :navigations, :order_id, :integer
  end
end

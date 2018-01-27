class AddParentToItems < ActiveRecord::Migration[5.1]
  def change
    #remove_column :items, :item_id_id
    #add_reference :items, :parent_id, :class_name => 'Items', foreign_key: true
  end
end

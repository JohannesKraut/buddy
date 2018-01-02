class AddSavingsToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :savings, :boolean
  end
end

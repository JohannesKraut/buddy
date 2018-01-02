class AddBudgetToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :budget, :boolean
  end
end

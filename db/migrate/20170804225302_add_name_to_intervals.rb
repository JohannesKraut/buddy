class AddNameToIntervals < ActiveRecord::Migration[5.1]
  def change
    add_column :intervals, :name, :string
  end
end

class AddTextToMonthlyStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_statistics, :text, :string
  end
end

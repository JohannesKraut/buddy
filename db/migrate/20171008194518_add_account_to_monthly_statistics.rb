class AddAccountToMonthlyStatistics < ActiveRecord::Migration[5.1]
  def change
    add_reference :monthly_statistics, :account, foreign_key: true
  end
end

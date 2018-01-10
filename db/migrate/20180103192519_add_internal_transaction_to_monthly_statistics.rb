class AddInternalTransactionToMonthlyStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_statistics, :internal_transaction, :boolean
  end
end

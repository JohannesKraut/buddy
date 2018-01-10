class AddReservePaymentToMonthlyStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_statistics, :reserve_payment, :boolean
  end
end

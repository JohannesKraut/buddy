class AddReserveReleaseToMonthlyStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_statistics, :reserve_release, :boolean
  end
end

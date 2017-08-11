class AddHibiscusSyncIdToMonthlyStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_statistics, :hibiscus_sync_id, :integer
  end
end

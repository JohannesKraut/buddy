class AddMatchDetailsToMonthlyStatistic < ActiveRecord::Migration[5.1]
  def change
    add_column :monthly_statistics, :match_confidence, :decimal, precision: 8, scale: 2
    add_column :monthly_statistics, :match_type, :string
    add_column :monthly_statistics, :match_value, :string
  end
end

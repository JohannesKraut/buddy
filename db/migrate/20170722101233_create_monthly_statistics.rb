class CreateMonthlyStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :monthly_statistics do |t|
      t.date :period
      t.decimal :planned_value, precision: 8, scale: 2
      t.decimal :actual_value, precision: 8, scale: 2
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end

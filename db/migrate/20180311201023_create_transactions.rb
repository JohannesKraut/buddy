class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :account, index: true
      t.belongs_to :monthly_statistic, index: true
      t.timestamps
    end
  end
end

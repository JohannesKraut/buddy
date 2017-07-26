class CreateFinanceStates < ActiveRecord::Migration[5.1]
  def change
    create_table :finance_states do |t|
      t.date :period
      t.integer :hibiscus_sync_id
      t.decimal :balance, precision: 8, scale: 2
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end

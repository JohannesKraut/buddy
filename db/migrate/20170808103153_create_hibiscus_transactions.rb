class CreateHibiscusTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :hibiscus_transactions do |t|

      t.timestamps
    end
  end
end

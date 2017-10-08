class CreateHibiscusAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :hibiscus_accounts do |t|

      t.timestamps
    end
  end
end

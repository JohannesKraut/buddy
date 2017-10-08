class AddHibiscusAccountIdToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :hibiscus_account_id, :integer
  end
end

class AddDefaultItemToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :accounts, :item, foreign_key: true
  end
end

class AddUserToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :accounts, :user, foreign_key: true, :default => 2
  end
end

class AddAccountToItems < ActiveRecord::Migration[5.1]
  def change
    #change_column :items, :account_id, :string
    add_reference :items, :account, foreign_key: true
  end
end

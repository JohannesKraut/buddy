class AddExternalAccountToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :external_account, :string
  end
end

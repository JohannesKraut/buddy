class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :account_number
      t.string :description
      t.string :iban
      t.string :bic

      t.timestamps
    end
  end
end

class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer :order_id
      t.string :name
      t.decimal :total_amount, precision: 8, scale: 2
      t.decimal :amount_calculated, precision: 8, scale: 2
      t.boolean :reserve
      t.date :maturity
      t.boolean :active
      t.references :category, foreign_key: true
      t.references :interval, foreign_key: true

      t.timestamps
    end
  end
end

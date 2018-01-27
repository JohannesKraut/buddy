class CreateSavings < ActiveRecord::Migration[5.1]
  def change
    create_table :savings do |t|
      t.string :name
      t.string :description
      t.integer :duration

      t.timestamps
    end
  end
end

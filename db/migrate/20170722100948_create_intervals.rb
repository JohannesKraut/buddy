class CreateIntervals < ActiveRecord::Migration[5.1]
  def change
    create_table :intervals do |t|
      t.decimal :numerator, precision: 8, scale: 2
      t.decimal :denominator, precision: 8, scale: 2
      t.string :description

      t.timestamps
    end
  end
end

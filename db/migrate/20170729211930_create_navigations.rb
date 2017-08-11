class CreateNavigations < ActiveRecord::Migration[5.1]
  def change
    create_table :navigations do |t|
      t.string :display_text
      t.string :url
      t.string :html_class
      t.integer :parent

      t.timestamps
    end
  end
end

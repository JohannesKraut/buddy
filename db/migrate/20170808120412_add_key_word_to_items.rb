class AddKeyWordToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :key_words, :string
  end
end

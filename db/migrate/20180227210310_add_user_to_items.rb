class AddUserToItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :user, foreign_key: true, :default => 2
  end
end

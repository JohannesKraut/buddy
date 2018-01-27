class AddSavingsToItems < ActiveRecord::Migration[5.1]
  def change
    #add_column :items, :savings, :boolean
    #add_reference :items, :savings, foreign_key: true
    #change_column :items, :savings, foreign_key: true
    add_reference :items, :savings, foreign_key: true
    Item.update_all(savings_id: 4)
  end
  
  def up
    
    add_reference :items, :savings, foreign_key: true
    Item.update_all(savings: 4)
  end
  
  def down
    remove_column :items, :savings
  end
end

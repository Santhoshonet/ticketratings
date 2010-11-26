class CreateRankcriterias < ActiveRecord::Migration
  def self.up
    create_table :rankcriterias do |t|
      t.text :phrase
      t.boolean :priorityhigh
      t.timestamps
      
    end
    add_index("rankcriterias","phrase")
  end

  def self.down
    drop_table :rankcriterias
  end
end

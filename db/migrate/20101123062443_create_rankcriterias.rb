class CreateRankcriterias < ActiveRecord::Migration
  def self.up
    create_table :rankcriterias do |t|
      t.text :phrase
      t.boolean :priorityhigh

      t.timestamps
    end
  end

  def self.down
    drop_table :rankcriterias
  end
end

class CreateAlternatephrases < ActiveRecord::Migration
  def self.up
    create_table :alternatephrases do |t|
      t.string :word
      t.string :equalto

      t.timestamps
    end
  end

  def self.down
    drop_table :alternatephrases
  end
end

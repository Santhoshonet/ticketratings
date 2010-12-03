class CreateNotoperators < ActiveRecord::Migration
  def self.up
    create_table :notoperators do |t|
      t.string :operator
      t.timestamps
    end
  end

  def self.down
    drop_table :notoperators
  end
end

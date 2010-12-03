class CreateIgnorephrases < ActiveRecord::Migration
  def self.up
    create_table :ignorephrases do |t|
      t.string :phrase
      t.timestamps
    end
    add_column('rankcriterias','isantonymprocessed',"boolean",:default => "false")
    Rankcriteria.count_by_sql("update rankcriterias set isantonymprocessed='false'")
  end
  def self.down
    drop_table :ignorephrases
  end
end

class CreateCategoryConferences < ActiveRecord::Migration
  def self.up
    create_table :category_conferences do |t|
      t.integer :conference_id
      t.integer :category_id

      t.timestamps
    end
    add_foreign_key :category_conferences, :conference_id, :references => :conferences
    add_foreign_key :category_conferences, :category_id, :references => :categories
  end

  def self.down
    drop_table :category_conferences
  end
end

class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :version
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_foreign_key :categories, :parent_id, :references => :categories
  end

  def self.down
    drop_table :categories
  end
end

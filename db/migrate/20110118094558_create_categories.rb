class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :lock_version, :default=>0 #active_record built_in
      t.string :name
      t.string :ancestry
      t.integer :ancestry_depth

      t.timestamps
    end
    add_index :categories, :ancestry
  end

  def self.down
    drop_table :categories
  end
end

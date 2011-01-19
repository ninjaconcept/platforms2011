class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id
      t.text :text
      t.boolean :read, :default=>0, :null=>false

      t.timestamps
    end
    add_foreign_key :notifications, :user_id, :references => :users
  end

  def self.down
    drop_table :notifications
  end
end
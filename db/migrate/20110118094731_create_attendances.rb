class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances, :id => false do |t|
      t.integer :conference_id
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :attendances, :user_id, :references => :users
    add_foreign_key :attendances, :conference_id, :references => :conferences
  end

  def self.down
    drop_table :attendances
  end
end
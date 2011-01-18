class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees, :id => false do |t|
      t.integer :conference_id
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :attendees, :user_id, :references => :users
    add_foreign_key :attendees, :conference_id, :references => :conferences
  end

  def self.down
    drop_table :attendees
  end
end
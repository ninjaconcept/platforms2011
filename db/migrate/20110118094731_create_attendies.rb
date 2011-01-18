class CreateAttendies < ActiveRecord::Migration
  def self.up
    create_table :attendies do |t|
      t.integer :conference_id
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :attendies, :user_id, :references => :users
    add_foreign_key :attendies, :conference_id, :references => :conferences
  end

  def self.down
    drop_table :attendies
  end
end

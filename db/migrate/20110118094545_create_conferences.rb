class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.integer :lock_version, :default=>0 #active_record built_in
      t.string :name
      t.integer :creator_user_id
      t.integer :series_id
      t.date :start_date
      t.date :end_date
      t.string :description
      t.string :location

      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10

      #t.float :gps_long
      #t.float :gps_lat
      t.string :venue
      t.string :accomodation
      t.string :howtofind

      t.timestamps
    end
    add_foreign_key :conferences, :series_id, :references => :series
    add_foreign_key :conferences, :creator_user_id, :references => :users
  end

  def self.down
    drop_table :conferences
  end
end

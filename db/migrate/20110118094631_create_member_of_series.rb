class CreateMemberOfSeries < ActiveRecord::Migration
  def self.up
    create_table :member_of_series do |t|
      t.integer :series_id
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :member_of_series, :user_id, :references => :users
    add_foreign_key :member_of_series, :series_id, :references => :series
  end

  def self.down
    drop_table :member_of_series
  end
end

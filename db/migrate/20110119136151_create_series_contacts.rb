class CreateSeriesContacts < ActiveRecord::Migration
  def self.up
    create_table :series_contacts, :id => false do |t|
      t.integer :series_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :series_contacts
  end
end

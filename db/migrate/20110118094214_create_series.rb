class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.integer :version, :default=>0
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :series
  end
end

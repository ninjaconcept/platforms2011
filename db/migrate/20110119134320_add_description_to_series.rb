class AddDescriptionToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :description, :text
  end

  def self.down
    remove_column :series, :description
  end
end

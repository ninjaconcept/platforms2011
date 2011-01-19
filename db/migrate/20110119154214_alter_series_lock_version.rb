class AlterSeriesLockVersion < ActiveRecord::Migration
  def self.up
    remove_column :series, :version
    add_column :series, :lock_version, :integer, :default=>0
  end

  def self.down
    add_column :series, :version, :integer, :default=>0
    remove_column :series, :lock_version
  end
end

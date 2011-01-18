class CreateRcdStatuses < ActiveRecord::Migration
  def self.up
    create_table :rcd_statuses do |t|
      t.integer :inviter_user_id
      t.integer :invitee_user_id
      t.string :status

      t.timestamps
    end
    add_foreign_key :rcd_statuses, :inviter_user_id, :references => :users
    add_foreign_key :rcd_statuses, :invitee_user_id, :references => :users
  end

  def self.down
    drop_table :rcd_statuses
  end
end

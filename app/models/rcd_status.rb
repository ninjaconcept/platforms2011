class RcdStatus < ActiveRecord::Base
  belongs_to :invitee_user, :class_name=>"User"
  belongs_to :inviter_user, :class_name=>"User"
  
  before_create :initial_status
  
  def initial_status
    self.status = "sent"
  end
  
  def status_for_user(user)
    case [user.id, status]
    when [inviter_user.id, "sent"]
      "RCD_sent"
    when [invitee_user.id, "sent"]
      "RCD_received"
    when [user.id, "accepted"]
      "in_contact"
    end
  end
  
  def self.for_users(from, to)
    self.where("(invitee_user_id = ? AND inviter_user_id = ?) OR (inviter_user_id = ? AND invitee_user_id = ?)", from.id, to.id, from.id, to.id).first
  end
  
  def self.send_rcd(from, to)
    self.create!(:inviter_user => from, :invitee_user => to)
  end
  
  def get_other me
    me.id==inviter_user_id ? invitee_user : inviter_user
  end

  def accept!
    self.status = "in_contact"
    self.save
  end
  
  def reject!
    self.status = "no_contact"
    self.save
  end
end

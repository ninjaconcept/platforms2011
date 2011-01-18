class RcdStatus < ActiveRecord::Base
  belongs_to :invitee_user_id, :class_name=>"User"
  belongs_to :inviter_user_id, :class_name=>"User"
  
  before_create :initial_status
  
  def initial_status
    "sent"
  end
  
  def status_for_user(user)
    case [user.id, status]
    when [inviter_user_id, "sent"]
      "RCD_sent"
    when [invitee_user_id, "sent"]
      "RCD_received"
    when [user.id, "accepted"]
      "in_contact"
    end
  end
  
  def self.for_users(from, to)
    self.find("(invitee_user_id = ? AND inviter_user_id = ?) OR (inviter_user_id = ? AND invitee_user_id = ?)", 
              [from.id, to.id, from.id, to.id])
  end
  
  def accept!
    self.status = "in_contact"
  end
  
  def reject!
    self.status = "no_contact"
  end
end

class RcdStatus < ActiveRecord::Base
  belongs_to :invitee_user_id, :class_name=>"User"
  belongs_to :inviter_user_id, :class_name=>"User"
end

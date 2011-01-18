# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :rcd_status do |f|
  f.inviter_user_id 1
  f.invitee_user_id 1
  f.status "MyString"
end

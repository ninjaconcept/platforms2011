# Factory.define :user do |u|
#   u.email
#   u.password
#   u.password_confirmation { |u| u.password }
#   
#   u.remember_me false
#   
#   # u.encrypted_password
#   # u.password_salt
#   # u.remember_token
#   # u.remember_created_at Time.now
#   # u.unlock_token
#   # u.authentication_token
# 
#   # u.reset_password_token
#   # u.sign_in_count
#   # u.current_sign_in_at
#   # u.last_sign_in_at
#   # u.current_sign_in_ip
#   # u.last_sign_in_ip
#   # u.failed_attempts
#   # u.locked_at
#   # u.created_at
#   # u.updated_at
# end

Factory.define :user do |f|
  f.sequence(:email) {|n| "user#{n}@plat-forms.org" }
  f.password 'super-secret-password'
  f.password_confirmation { |u| u.password }
  f.remember_me false
end
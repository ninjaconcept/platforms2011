Factory.define :user do |f|
  f.sequence(:email) {|n| "user#{n}@plat-forms.org" }
  f.sequence(:username) {|n| "username#{n}" }
  f.password 'super-secret'
  f.password_confirmation { |u| u.password }
  f.remember_me false
  f.town "Munich"
  f.country "Germany"
  f.fullname "Stevie B"
  f.lat ''
  f.lng ''
end
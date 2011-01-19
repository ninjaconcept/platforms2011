# origin: M

# Join model: users that attend a conference

class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference
end
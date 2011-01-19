# origin: M

#This class tracks notifications

class Notification < ActiveRecord::Base
  belongs_to :user
end
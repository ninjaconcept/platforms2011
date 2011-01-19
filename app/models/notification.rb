# origin: M

#This class manages Notification, both for users as well as the webservice

class Notification < ActiveRecord::Base
  belongs_to :user
end
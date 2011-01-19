#origin GM

# Authentication class for use by the authentication layer

class Authentication < ActiveRecord::Base
  belongs_to :user
end

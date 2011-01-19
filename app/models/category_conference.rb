#origin GM

# join model between categories and conferences 
# 
class CategoryConference < ActiveRecord::Base
  belongs_to :category
  belongs_to :conference
end

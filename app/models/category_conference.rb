class CategoryConference < ActiveRecord::Base
  belongs_to :category
  belongs_to :conference
end

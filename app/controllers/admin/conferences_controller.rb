#origin GM

# This class provides the interface for admins to create categories


class Admin::ConferencesController < Admin::BaseController
  belongs_to :category, :optional => true
  belongs_to :series, :optional => true
  
  def index
    @search_term = params[:conference][:search_term] if params[:conference]
    term = "%#{@search_term}%"

    @users = User.where("location LIKE ? OR name LIKE ?", term, term)
    
    index!
  end
end
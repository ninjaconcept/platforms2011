#origin GM

class CategoriesController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show, :by_id]
  before_filter :require_admin, :except => [:index, :show, :by_id]
  
  respond_to :html, :json
  
  def index
    
    respond_to do |format|
      format.json { c = Category.all; empty_safe(c) { render :json => c } }
      format.html { index_page }
    end
  end

  def show
    respond_to do |format|
      format.json { c = Category.find(params[:id]); render :json => c }
      format.html do
        index_page params[:id]
        render :template=>"categories/index"
      end
    end
  end
  
  def create
    p = params[:conference] || request.POST
    parent = p.delete(:parent)

    @category = Category.new(p)
    
    if parent
      @category.parent = Category.find_by_name(parent[:name])
    end
    
    create! do |success, failure|
      success.json { response.status = 200; render :json => @category }
      failure.json { head 400 }
    end
  end
  
  def by_id
    respond_to do |format|
      format.json do
        c = Category.find(params[:id]).conferences
        empty_safe(c) {render :json => c }
      end
    end
  end

  private

  def index_page id=nil
    time_format="%Y-%m-%d"
    @current_category=Category.find(id) if id
    @categories=@current_category ? @current_category.descendants : Category.roots
    if id
      cat_string=@categories.map{|cat|" cat:#{cat.name} " }.join " "
    end
    @conferences=Conference.all.paginate :per_page=>10
    @running_conferences=ConferenceSearcher.do_find "#{cat_string} from:#{Date.today} until:#{Date.today} ", current_user
    @upcoming_conferences=ConferenceSearcher.do_find "#{cat_string}", current_user, Conference.where("start_date=?",1.day.from_now.strftime(time_format)) #alle Kategorien suchen plus die, die morgen starten
    @nextweek_conferences=ConferenceSearcher.do_find "#{cat_string}", current_user, Conference.where("start_date BETWEEN ? AND ?",1.week.from_now.monday.strftime(time_format), 1.week.from_now.end_of_week.strftime(time_format))
  end
end

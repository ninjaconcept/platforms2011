class CategoriesController < InheritedResources::Base

  def index
    index_page
  end


  def show
    index_page params[:id]
    render :template=>"categories/index"
  end

  private

  def index_page id=nil
    time_format="%Y-%m-%d"
    @current_category=Category.find_by_name(id) if id
    @categories=@current_category ? @current_category.descendants : Category.all
    if id
      cat_string=@categories.map{|cat|" cat:#{cat.name} " }.join " "
    end
    @conferences=Conference.all.paginate :per_page=>10
    @running_conferences=ConferenceSearcher.do_find "#{cat_string} from:#{Date.today} until:#{Date.today} ", current_user
    @upcoming_conferences=ConferenceSearcher.do_find "#{cat_string}", current_user, Conference.where("start_date=?",1.day.from_now.strftime("%Y-%m-%d")) #alle Kategorien suchen plus die, die morgen starten
    @nextweek_conferences=ConferenceSearcher.do_find "#{cat_string}", current_user, Conference.where("start_date BETWEEN ? AND ?",1.week.from_now.monday.strftime("%Y-%m-%d"), 1.week.from_now.end_of_week.strftime("%Y-%m-%d")) #alle Kategorien suchen plus die, die morgen starten
  end
end

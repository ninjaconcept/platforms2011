# class BaseController < InheritedResources::Base
#   actions :index, :show
#   respond_to :html#, :xml, :json
# end

class BaseController < InheritedResources::Base
  
  
  actions :index, :show, :new, :edit, :create, :update, :destroy
  respond_to :html, :js, :json # :xml

 
  def show!
    authorize_instance :read
    super
  end
  
  def new!
    authorize_class :create
    super
  end
  
  def create!
    authorize_class :create
    super
  end
  
  def edit!
    authorize_instance :update
    super
  end
  
  def update!
    authorize_instance :update 
    super
  end
  
  def show
    show!
  end
  
  def new
    new!
  end
  
  def create
    create!
  end
  
  def edit
    edit!
  end
  
  def update
    update!
  end
  
  
  
  protected 
    
    def authorize_instance action
      assign_resource
      authorize! action, resource
    end

    def authorize_class action
      authorize! action, resource_class
    end
      
      
  protected
  
    def collection  
      paginated_collection 
    end
    
    def collection_symbol
      controller_name.to_sym
    end
    
    def resource_symbol
      resource_class.name.underscore.to_sym
    end
    
    def assign_resource
      instance_variable_set( "@#{resource_symbol}", resource )
    end
    
    
    def collection_with_permission_to_read
      _collection = respond_to?(:begin_of_paginated_collection) ? begin_of_paginated_collection : end_of_association_chain 
      if action_name == 'index'
        begin
          _collection.accessible_by(current_ability, :read)
        rescue CanCan::Error
          _collection.all.select{|resource| can?(:read, resource) rescue false}
        end
      else
        super
      end
    end
      
    
    def paginated_collection 
      
        _per_page = per_page rescue 15
        _collection = collection_with_permission_to_read
      
        paginate_options ||= {}
        paginate_options[:page] ||= (params[:page] || 1)
        paginate_options[:per_page] ||= (params[:per_page] || _per_page)
        paginate_options[:group] = @paginate_group_by if @paginate_group_by

        _paginated_collection = _collection ? _collection.paginate(paginate_options) : _collection

        if !sorted_by_column_header? && !_paginated_collection.empty? && _paginated_collection.first.respond_to?(:position)
          _paginated_collection = _paginated_collection.sort{|a,b| (a.position || 0) <=> (b.position || 0) }
        end

        unless instance_variable_get( "@#{collection_symbol}" )
          instance_variable_set( "@#{collection_symbol}", _paginated_collection ) 
        else
          instance_variable_get( "@#{collection_symbol}" )
        end

    end
    
  
    ########
    # IR fixes !!!
    
  public  
    before_filter :trigger_parent_assignment
      
    # fixes empty parent in controller bug 
    def trigger_parent_assignment
      begin
        association_chain
      rescue
      end
    end
  
  private
    def sorted_by_column_header?
      !params[:search].blank? && !params[:search][:order].blank?
    end
    
end
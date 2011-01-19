class Category < ActiveRecord::Base

  has_ancestry :cache_depth => true, :orphan_strategy => :destroy
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true  
    
  has_many :category_conferences, :dependent => :destroy
  has_many :conferences, :through => :category_conferences
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  include Pacecar
  
  def version
    lock_version
  end
  
  def version=(arg)
    self.lock_version = arg
  end
  
  def subcategories
    children.map {|c| {:name => c.name}}
  end
  
  def parent_name
    {:name => parent.name} if parent
  end
  
  def to_json(opts = {})
    if new_record?
      super(
        :only => [:version, :id, :name]
      )
    else
      j = super(
        :only => [:version, :id, :name],
        :methods => [:parent_name, :subcategories]
      )
      
      #argh, what a hack
      h = JSON.parse(j)
      h[:parent] = h.delete(:parent_name)
      JSON.dump(h) 
    end
  end
end

class ConferenceSearcher

  def self.search opts, user=current_user
    query=Conference
    if opts["until"]
      query=query.where("end_date <= ?",Date.parse(opts["until"]))
    end
    if opts["from"]
      query=query.where("start_date >= ?",Date.parse(opts["from"]))
    end
    if opts["until"].nil? and opts["from"].nil?
      query=query.where("start_date > ?",Date.today) #see S31
    end
    if opts["cat"]
      #cat_ids=Category.find_all_by_name(opts["cat"])
      query=query.includes(:categories)
      #query=query.where("categories.name in (?)", opts["cat"])
      cats=Category.find_all_by_name(opts["cat"].map{|cat_name|cat_name.gsub("_"," ")}) #this was defined with the customer: since "cat:Life Science" contains a space, the query syntax should be "cat:Life_Science"
      cat_ids=[] #empty
      if opts["opt"]=="withsub" #add sub cat ids
        cats.each do |cat|
          cat_ids+=cat.subtree_ids
        end
      end
      cat_ids+=cats.map{|c|c.id}  #add the cat itself
      query=query.where("categories.id in (?)", cat_ids) #and fire
    end
    if opts["reg"]=="country"
      country="%#{user.country}%" #prepare for like syntax
      query=query.where("location like ?",country ) 
    elsif opts["reg"]=~/\d+/
      raise "User #{user.username} has no GPS data given, fix this in the UI" if user.gps.blank?
      query=query.within(opts["reg"].to_i, :origin=>user) #geokit ist so cool!
    end
    puts query.to_sql
    query.paginate :page=>1
  end

  def self.parse string
    hash={}
    arr=string.split
    arr.each do |element|
      if element=~/\:/
        key,value=element.split(":")
        if key=="cat" #only "cat" may be arrays
          hash[key]||=[]
          hash[key]<<value
        else
          hash[key]=value
        end
      else
        hash["text"]||=[]
        hash["text"]<<element
      end
    end
    hash
  end

  def self.do_find string, user
    hash=parse string
    search hash, user
  end
end

ConferenceSearcher.do_find "reg:50", User.first

#ConferenceSearcher.do_find ""

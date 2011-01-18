class ConferenceSearcher
  def self.search opts
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
      country=defined?(current_user) ? (current_user.country) : "Switzerland"
      country="%#{country}%" #prepare for like syntax
      query=query.where("location like ?",country ) #in test env it should always use Switzerland...
    elsif opts["reg"]=~/\d+/
      #query=query.where("county=?",defined?(current_user) ? (current_user.country) : "Switzerland" ) #in test env it should always use Switzerland...
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
        #        last_key=key
        if key=="cat" #only those may be arrays
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
    #hash["from"]=
    hash
  end
  def self.do_find string
    hash=parse string
    search hash
  end

  def self.adjust_parsed_hash hash
    #if hash["from"].nil? and hash["until"].nil?
    #  #hash["from"]
    #end
  end

end

ConferenceSearcher.do_find "reg:country"


#ConferenceSearcher.do_find ""

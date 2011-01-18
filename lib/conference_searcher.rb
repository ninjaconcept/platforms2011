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
      query=query.where("categories.name in (?)", opts["cat"])
    end
    if opts["opt"]=="withsub"
      #TODO
    end
    if opts["reg"]=="country"
      query=query.where("county=?",defined?(current_user) ? (current_user.country) : "Switzerland" ) #in test env it should always use Switzerland...
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

ConferenceSearcher.do_find "cat:Technology"
#ConferenceSearcher.do_find ""

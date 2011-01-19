require 'json'

class FactoryDefaults
  def self.import

    json = File.new("#{Rails.root}/db/data.json", 'r').read
    array=JSON::parse(json)
    users=array[0]
    categories=array[1]
    member_of_series=array[2]
    conferences=array[3]

    u_hash=users[0] #for manual testing...
    users.each do |u_hash|
      #adjust hash, so we can use it directly
      u_hash["password_confirmation"]=u_hash["password"]
      u_hash["email"]=u_hash["email"].strip #error in json data
      puts "creating user #{u_hash["username"]}"
      User.create!(u_hash) #this works, since username etc. is also attr_accessible...
    end

    categories.each do |c_hash|
      parent_name=c_hash["parent"]["name"] if c_hash["parent"]
      if parent_name
        #parent_cat=Category.find_by_name(parent_name)
        #if parent_cat.nil?
        #  parent_cat=Category.create!(:name=>parent_name) #if not found, create it
        #end
        parent_cat=Category.find_or_create_by_name(parent_name)
        c_hash["parent"] = parent_cat
      end
      c_hash.delete "subcategories" #should be redundant to parent
      #c_hash.delete "parent" #
      puts "creating/updating category #{c_hash["name"]}"
      cat=Category.find_by_name(c_hash["name"])
      if cat
        cat.update_attributes(c_hash)
      else
        Category.create(c_hash)
      end
    end

    member_of_series.each do |ms_hash|
      series=Series.create!(:name=>ms_hash["name"])
      username=ms_hash["contacts"][0]["username"] #simple enough here, because testdata always follows this scheme
      series.contacts<<User.find_by_username(username)
      #MemberOfSeries.create!(:series_id=>series.id, :user_id=>User.find_by_username(username).id)
    end

    conf_hash=conferences[1]
    conferences.each do |conf_hash|
      conf_hash["creator"]=User.find_by_username(conf_hash["creator"]["username"]) #creater attribute has another semantic now: it's a Rails Model
      if (conf_hash["series"] and conf_hash["series"]["name"]) #may be empty
        conf_hash["series_id"]=Series.find_by_name(conf_hash["series"]["name"]).id
      end
      conf_hash.delete "series"
      conf_hash["start_date"]=Date.parse(conf_hash["startdate"]) #luckily Rails swallows this input format: 20091227
      conf_hash.delete "startdate"
      conf_hash["end_date"]=Date.parse(conf_hash["enddate"]) #dito
      conf_hash.delete "enddate"
      categories_array=conf_hash.delete "categories"
      #conf_hash.delete "gps"
      conf_hash["description"] = "_" if conf_hash["description"].blank? #mandatory field, must not be empty
      puts "creating conference #{conf_hash["name"]}"
      conf=Conference.new(conf_hash)
      conf.creator=conf_hash["creator"]  #not mass_assignable for security reasons...
      conf.just_created=true # set it, so it won't complain about missin categories (they will be added in some ms)
      conf.save!
      new_confs=categories_array.map do |cat_hash|
        cat=Category.find_by_name(cat_hash["name"])
        CategoryConference.create!(:conference=>conf, :category=>cat)
      end
      if new_confs.empty?
        CategoryConference.create!(:conference=>conf, :category=>Category.first) #customer said, we should take the first cat, when none is available (so we conform to M56)
      end
    end
    
    self.create_admin
  end

  def self.reset
    `cd #{RAILS_ROOT}; RAILS_ENV=#{RAILS_ENV} rake db:drop db:create db:migrate`
  end
  
  def self.create_admin
    # M143
    User.create!( 
          :username => 'admin', :password => 'admin', :email => 'admin@plat-forms.org', 
          :town => 'Nuernberg', :country => 'Germany', :fullname => 'Admin', :is_administrator => true
    )
  end
end
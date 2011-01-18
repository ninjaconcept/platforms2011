require "spec_helper"

def search string, result_size
  result=ConferenceSearcher.do_find string, User.first
  s="#{string}: "
  s<<result.map{|r|r.start_date}.join(", ")
  s<<" "
  s<<result.map{|r|"["+r.categories.map{|c|c.name}.join(", ")+"]"}.join(", ")
  #puts s
  result.size.should==result_size 
end

describe ConferenceSearcher do
  it "searches from and until" do
    search "from:20111201", 2
    search "until:2010/12/01", 4
    search "from:1.12.2009 until:31.12.2009", 1
    search "", Conference.where("start_date>=CURRENT_DATE()").size #get the ony from today
    search "from:1.12.2009 until:31.12.2009", 1
  end
  it "searches cats" do
    search "cat:Technology", 6
    search "cat:Sciences ", 8
    search "cat:Technology    cat:Sciences", 14
    search "cat:Life_Science", 4
  end
  it "searches cats with subcats" do
    search "cat:Life_Science opt:withsub", 4 #a little sad, that the test data also returns 4 here
    search "cat:Technology opt:withsub", 6
  end
  it "searches region" do
    search "reg:country", 3 #in test, United States is the country where the search will happen
    search "reg:1000", 4  #1000km around bill gates. finds some confs in US
  end
  it "searches text" do
    search "from:1.1.2006 CCC until:20130101", 3
    search "from:1.1.2006 CCC until:20060101", 0 #not in 2006
  end
end
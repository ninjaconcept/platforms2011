require "spec_helper"

def search string, result_size
  result=ConferenceSearcher.do_find string
  s="#{string}: "
  s<<result.map{|r|r.start_date}.join(", ")
  s<<" "
  s<<result.map{|r|"["+r.categories.map{|c|c.name}.join(", ")+"]"}.join(", ")
  puts s
  result.size.should==result_size 
end

describe ConferenceSearcher do
  if false
    it "searches from and until" do
      search "from:20111201", 2
      search "until:2010/12/01", 4
      search "from:1.12.2009 until:31.12.2009", 1
      search "", Conference.count("start_date>today()") #get the ony from today
      search "from:1.12.2009 until:31.12.2009", 1
    end
    it "searches cats" do
      search "cat:Technology", 6
      search "cat:Sciences ", 8
      search "cat:Technology cat:Sciences", 14
      search "cat:Life_Science", 4
    end
    it "searches cats with subcats" do
      search "cat:Life_Science opt:withsub", 4 #a little sad, that the test data also returns 4 here
      search "cat:Technology opt:withsub", 6
    end
  end
  it "searches region" do
    search "reg:country", 4 #in test, Switzerland is the country where the search will happen
    search "reg:50", 4 #in test, Switzerland is the country where the search will happen
  end
end
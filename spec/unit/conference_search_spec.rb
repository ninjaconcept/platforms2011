require "spec_helper"

def search string, result_size
  result=ConferenceSearcher.do_find string
  s="#{string}: "
  s<<result.map{|r|r.start_date}.join(", ")
  s<<" "
  s<<result.map{|r|"["+r.categories.map{|c|c.name}.join(", ")+"]"}.join(", ")
  puts s
  result.size.should==result_size #
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
  end
  it "searches cats" do
    search "cat:Technology", 6
    search "cat:Technology cat:Science ", 6
  end
end
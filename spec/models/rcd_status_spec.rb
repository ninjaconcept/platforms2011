#origin G

require 'spec_helper'

describe RcdStatus do
  context "A makes contact with B" do
    before do
      @s = User.find_by_username("aturing")
      @b = User.find_by_username("bgates")
      @r = RcdStatus.send_rcd(@s, @b)
    end
    
    it "should be in steves list" do
      @s.rcd_statuses.size.should == 1
    end
    
    it "should be in bills list" do
      @s.rcd_statuses.size.should == 1
    end
    
    it "should be RCD_sent for aturing" do
      @r.status_for_user(@s).should == "RCD_sent"
    end
    
    it "should be RCD_received for bill" do
      @r.status_for_user(@b).should == "RCD_received"
    end
    
  end
end

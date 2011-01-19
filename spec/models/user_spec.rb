# origin: M
require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:fullname) }
  it { should validate_presence_of(:town) }
  it { should validate_presence_of(:country) }
  
  # it { should validate_format_of(:gps).with(GPS_REGEX) }
  
  # it { should validate_format_of(:gps_lat).with(/\d+(\.\d+)?/) }
  # it { should validate_format_of(:gps_long).with(/\d+(\.\d+)?/) }
  
  
  context "with existing users" do
    before do
      @user = Factory(:user)
    end
    subject { @user }
    
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }
  
    it "should respond to is_admin?" do
      @user.should respond_to('is_admin?')
    end

    it "should gecode by an address" do
      @user.town="Nuernberg"
      @user.country="Deutschland"
      Float(@user.lat).should be_close(48.1391265, 0.5)
      Float(@user.lng).should be_close(11.08048, 0.5)
    end
  end
  

end
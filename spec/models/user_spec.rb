# origin: M
require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:fullname) }
  it { should validate_presence_of(:town) }
  it { should validate_presence_of(:country) }
  
  
  context "with existin users" do
    before do
      @user = Factory(:user)
    end
    subject { @user }
    
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }
  
    it "should respond to is_admin?" do
      @user.should respond_to('is_admin?')
    end
  end
  
end
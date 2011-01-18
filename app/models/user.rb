class User < ActiveRecord::Base
  
  has_many :authentications
  
  # Include default devise modules. Others available are:
  # :confirmable
  devise :database_authenticatable, :registerable, :lockable, :timeoutable, :recoverable,
         :rememberable, :trackable, :validatable, :token_authenticatable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :fullname, :town, :country
  
  
  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
end
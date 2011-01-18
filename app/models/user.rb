# origin: M
class User < ActiveRecord::Base
  
  has_many :authentications
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :lockable, :timeoutable, :recoverable,
         :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :fullname, :town, :country, :gps_lat, :gps_long
  
  validates_presence_of :fullname, :username, :town, :country
  validates_uniqueness_of :username, :email
  
  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def is_admin?
    is_administrator?
  end
  
end
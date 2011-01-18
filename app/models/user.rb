# origin: M
class User < ActiveRecord::Base
  
  has_many :authentications
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :lockable, :timeoutable, :recoverable,
         :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :fullname, :town, :country, :gps_lat, :gps_long
  
  # composed_of :gps, :mapping => [%w(gps_lat), %w(gps_long)]
  
  validates_presence_of :fullname, :username, :town, :country
  validates_uniqueness_of :username, :email
  validates_format_of :gps, :with => /\d+(\.\d+)? ?[NnSs] ?,? ?\d+(\.\d+)? ?[EeWw]/, :allow_blank => true
  
  #TODO: @flo composite field hinzufügen
  
  # validates_format_of :gps_lat, :with => /\d+(\.\d+)?/, :allow_blank => true
  # validates_format_of :gps_long, :with => /\d+(\.\d+)?/, :allow_blank => true

  
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
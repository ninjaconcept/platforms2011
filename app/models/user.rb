# origin: M
class User < ActiveRecord::Base

  acts_as_mappable :default_units => :kilometers,
    :default_formula => :flat,
    :distance_field_name => :distance,
    :lat_column_name => :lat,
    :lng_column_name => :lng
  #:auto_geocode=> { :field => :full_address, :error_message => 'Adresse konnte nicht in Koordinaten aufgelöst werden' }
  
  has_many :authentications
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :lockable, :timeoutable, :recoverable,
    :rememberable, :trackable, :validatable, :token_authenticatable, :confirmable

  #attr_accessor :gps
  # composed_of :gps, :mapping => [%w(lat), %w(lng)]
  #validates_format_of :gps, :with => /\d+(\.\d+)? ?[NnSs] ?,? ?\d+(\.\d+)? ?[EeWw]/, :allow_blank => true
  
  has_many :conferences, :foreign_key=>:creator_user_id, :dependent=>:destroy
  has_many :member_of_series, :dependent=>:destroy
  has_many :rcd_statuses,  :foreign_key=>:inviter_user_id, :dependent=>:destroy
  has_many :rcd_statuses,  :foreign_key=>:invitee_user_id, :dependent=>:destroy
  has_many :attendies, :dependent=>:destroy
  
  GPS_REGEX=/(\d+(\.\d+)?) ?([NnSs]) ?,? ?(\d+(\.\d+)?) ?([EeWw])/
  validates_format_of :gps, :with => GPS_REGEX, :allow_blank => true

  def gps
    "#{lat.abs}#{lat<0?"S":"N"},#{lng.abs}#{lng<0?"W":"E"}" #simple...
  end

  def gps= string
    unless string.blank?
      if string=~/NnSs/
        #format including N or S
        string.gsub("O","E") #change "O"st to "E"ast if applicable
        User::GPS_REGEX=~string
        lat=$1.to_f
        lat-lat if ["s","S"].include? $3
        lng=$4.to_f
        lng=-lng if ["w","W"].include? $6
      else
        #format is comething like "49 9" or "49,9" or "49.123,9.123"
        puts "ok"
        self.lat,self.lng=string.split(/ |,/)
        self.lat=2
      end
    end
  end



  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :fullname, :town, :country, :lat, :lng
  
  validates_presence_of :fullname, :username, :town, :country
  validates_uniqueness_of :username, :email
  
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
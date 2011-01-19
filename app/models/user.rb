# origin: M
class User < ActiveRecord::Base
  include GeoHelper
  class << self
    include GeoHelper
  end
  
  attr_accessor :search_term  
  
  acts_as_mappable acts_as_mappable_hash

  validate :geocode_address

  validates_format_of :gps, :with => GPS_REGEX, :allow_blank => true
  
  #:auto_geocode=> { :field => :full_address, :error_message => 'Adresse konnte nicht in Koordinaten aufgelöst werden' }
  
  has_many :authentications
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :lockable, :timeoutable, :recoverable,
    :rememberable, :trackable, :validatable, :confirmable

  #attr_accessor :gps
  # composed_of :gps, :mapping => [%w(lat), %w(lng)]
  #validates_format_of :gps, :with => /\d+(\.\d+)? ?[NnSs] ?,? ?\d+(\.\d+)? ?[EeWw]/, :allow_blank => true
  
  has_many :conferences, :foreign_key=>:creator_user_id, :dependent=>:destroy
  has_many :sent_statuses,  :foreign_key=>:inviter_user_id, :dependent=>:destroy, :class_name => "RcdStatus"
  has_many :received_statuses,  :foreign_key=>:invitee_user_id, :dependent=>:destroy, :class_name => "RcdStatus"
  has_many :attendances, :dependent=>:destroy
  has_many :notifications, :dependent=>:destroy
  
  def version
    lock_version
  end
  
  def version=(arg)
    self.lock_version = arg
  end

  def contacts
    RcdStatus.where("(inviter_user_id=? OR invitee_user_id=?)",id,id).where("status='in_contact'").map{|rcd|rcd.get_other(self)}
  end
  
  def rcd_statuses
    sent_statuses + received_statuses
  end
 
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, 
    :fullname, :town, :country, :lat, :lng, :is_administrator, :gps
  
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

  def full_address
    "#{town}, #{country}" rescue ''
  end
  
  def attends?(conference)
    attendances.find_by_conference_id(conference.id) rescue nil
  end
  
  def is_in_contact_with?(user)
    return true if user==self
    if rcd = RcdStatus.for_users(self, user)
      rcd.status == 'in_contact'
    end
  end
  
  
  def to_json(opts = {})
    full = opts.delete(:full)
    
    if full
      super(
        :only => [:id, :username, :password, :fullname, :email, :town, :country, :gps, :status],
        :methods => [:version]
      )
    else
      super(
        :only => [:username]
      )
    end
  end
  

  private

    def geocode_address
      unless full_address.blank? || full_address == ', ' || !(lat.blank? && lng.blank?)
        logger.debug "Full address: #{full_address}"
        geo = Geokit::Geocoders::MultiGeocoder.geocode( full_address )
        if geo.success
          self.lat, self.lng = geo.lat, geo.lng
        else
          #errors.add_to_base "Could not Geocode address"
        end
      end
    end
  
end

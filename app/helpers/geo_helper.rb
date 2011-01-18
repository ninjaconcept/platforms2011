module GeoHelper

  #works for user and conference the same way
  def acts_as_mappable_hash
    {
      :default_units => :kilometers,
      :default_formula => :flat,
      :distance_field_name => :distance,
      :lat_column_name => :lat,
      :lng_column_name => :lng
    }
  end

  GPS_REGEX=/(\d+(\.\d+)?) ?([NnSs]) ?,? ?(\d+(\.\d+)?) ?([EeWw])/

  def gps
    if lat.nil? or lng.nil? #NB: it would be wrong, if only of of both is nil
      ""
    else
      "#{lat.abs}#{lat<0?"S":"N"},#{lng.abs}#{lng<0?"W":"E"}" #simple...
    end
  end

  def gps= string
    unless string.blank?
      if string=~/NnSs/
        #format including N or S
        string.gsub("O","E") #change "O"st to "E"ast if applicable
        User::GPS_REGEX=~string
        self.lat=$1.to_f
        self.lat=-self.lat if ["s","S"].include? $3
        self.lng=$4.to_f
        self.lng=-self.lng if ["w","W"].include? $6
      else
        #format is comething like "49 9" or "49,9" or "49.123,9.123"
        self.lat,self.lng=string.split(/ |,/)
        #self.lat=2
      end
    end
  end


  #TODO: validate :geocode_address

  def full_address
    "#{town}, #{country}" rescue  ''
  end

  private

  def geocode_address
    unless full_address.blank? || full_address != ',' || !(lat.blank? && lng.blank?)
      logger.debug "Full address: #{full_address}"
      geo = Geokit::Geocoders::MultiGeocoder.geocode( full_address )
      if geo.success
        self.lat, self.lng = geo.lat, geo.lng
      else
        errors.add_to_base _("Could not Geocode address")
      end
    end
  end
end
class ConferenceSearcher
  def self.search opts
    Conference.paginate 
  end

  def self.parse string
    arr=string.split
  end
end
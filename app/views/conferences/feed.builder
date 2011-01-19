xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Attendees of Conference #{@conference.name}"
    xml.description "no desc, title is enough"
    @attendees.each do |user|
      xml.item do
        xml.title user.username
        if current_user and current_user.is_in_contact_with?(user)
          xml.description user.fullname
          xml.email user.email
        end
      end
    end
  end
end

#origin GM

# class to handle mail notifications

class UserMailer < ActionMailer::Base
  default :from => "info@n.plat-forms.org"

  def invite(conference, email, sending_user)
    @email = email
    @conference = conference
    @sending_user=sending_user
    mail(:to => email, :subject => "Invitation to join the conference #{conference.name}")
  end
  
end

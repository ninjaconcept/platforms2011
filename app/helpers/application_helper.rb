module ApplicationHelper
  
  def flash_messages
    msg = ''
    flash.each do |key, value|
      msg << <<-EOF
        <div id="flash-#{key}" class="flash-message #{key}">#{value}</div>
      EOF
    end
    msg.html_safe
  end
    
  # REVISION file is created while deploying
  def revision_string
    unless defined? @revision_string
      revision_file = File::join( Rails.root.to_s, 'REVISION' )
      @revision_string = if File.exists? revision_file
        File.open( revision_file ) do |file|
          file.readlines.first
        end
      end
    end
    @revision_string
  end
  
  # Body Class Helper
  
  def css_body_class(klass = nil)
    if klass.nil?
      @css_body_class || default_css_body_class
    else
      @css_body_class = "#{default_css_body_class} #{klass}"
    end
  end
  
  def default_css_body_class
    "#{controller.controller_name} #{controller.action_name} #{is_ipad? ? 'ipad' : ''}"
  end

  def page_title(title = nil)
    if title == nil
      @page_title || "#{controller.controller_name}: #{controller.action_name}"
    else
      @page_title = title + " | #{ApplicationSettings.page_title}"
    end
  end
  
  
  ##
  # use the following if required
  ##
    
  # def meta_description
  #   base = ApplicationSettings.meta_description
  #   additional = ''
  #   
  #   base + additional
  # end


  #parses a string
  def to_date string
    
  end


  def render_user_link user
    link_to user.fullname, user_path
  end

  def render_conference_link conference
    link_to conference.name, conference
  end

  def render_user_link_by_rcd_status rcd
    other_user=rcd.inviter_user_id==current_user.id ? rcd.invitee_user : rcd.inviter_user #get the other user, not the current one
    render_user_link other_user
  end
  
end

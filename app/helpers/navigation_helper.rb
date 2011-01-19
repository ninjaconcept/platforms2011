#origin GM

module NavigationHelper
  
  def render_navigation
    output = ''

    unless @category
      # render roots
      unless Category.roots.empty?
        output << content_tag(:ul, render_categories(Category.roots), :class => "menu level_#{Category.roots.first.ancestry_depth}" ) 
      end
    else
      
      ancestry_depth = @category.ancestry_depth.to_i
      category_path = @category.path
      
      category_path.each do |category|
        output << content_tag(:ul, render_categories(category.siblings), :class => "menu level_#{category.siblings.first.ancestry_depth}")
      end
      
      unless @category.children.empty?
        output << content_tag(:ul, render_categories(@category.children), :class => "menu level_#{@category.children.first.ancestry_depth}")
      end
      
      unless @category.documents.empty?
        output << content_tag(:ul, render_documents(@category.documents), :class => "document")
      end
      
    end
    
    output.html_safe
  end
  
  
  def render_categories(categories)
    logger.debug "!!!!! ***** Categories: #{categories.inspect}"
    
    _output = ''
    categories.each do |category|
      _output << content_tag( :li, link_to(category.name, permalink_category_path(category.permalink)).html_safe ).html_safe
    end
    
    _output.html_safe
  end
  
  def render_documents(documents)
    logger.debug "!!!!! ***** Documents: #{documents.inspect}"
    _output = ''
    documents.each{|doc|
      _output << content_tag(:li, link_to(doc.name, download_document_path(doc.permalink)).html_safe).html_safe
      }
    _output.html_safe  
  end

end
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  
  $.facebox.settings.closeImage = '/images/facebox/closelabel.png'
  $.facebox.settings.loadingImage = '/images/facebox/loading.gif'
  
  // $('.auth_provider.disabled').facebox({ div: '#auth-notice' });
  
  $('.auth_provider.disabled').click(function(){
    jQuery.facebox({ div: '#auth-notice' });
    // return false;
  });
})

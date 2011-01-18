#origin GM
class InvalidJSON < Exception; end
class MissingData < Exception; end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_json

  rescue_from(ActiveRecord::UnknownAttributeError){ |e| error_response(400, e) }
  rescue_from(InvalidJSON){ |e| error_response(400, e) }
  rescue_from(MissingData){ |e| error_response(400, e) }
  rescue_from(ActiveRecord::RecordNotFound){ |e| error_response(404, e) }
  
  private

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      root_path
    end
    
    def error_response(status, exception)
      respond_to do |format|
        format.html { "TODO: whatever" }
        format.any  { head status } # only return the status code
      end
    end
    
    def check_json
      raise InvalidJSON if params["_json"]
    end
end

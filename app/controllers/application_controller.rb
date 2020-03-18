class ApplicationController < ActionController::Base
  
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery
  before_action :set_current_user
 
  def set_current_user
    User.current = current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password_confirmation password avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email password_confirmation password avatar])  
  end



 

 
end



''
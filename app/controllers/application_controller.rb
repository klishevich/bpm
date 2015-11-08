class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  # after_action :verify_authorized, :except => [:index , :home]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end  

  def user_not_authorized
  	flash[:success] = t(:not_authorized)
  	redirect_to root_path
  end
 
end

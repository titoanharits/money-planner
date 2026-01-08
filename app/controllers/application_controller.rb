class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :email, :currency])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :email, :currency])
  end

  def after_sign_in_path_for(resource)
    if resource.needs_onboarding?
      onboarding_start_path
    else
      root_path
    end
  end
end

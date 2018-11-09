class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_core_user!, :set_locale

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_core_user
  end

  def current_user
    current_core_user
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    home_path
  end

  def set_locale
    I18n.locale = :en
  end

  def user_not_authorized
    flash[:warning] = t('controllers.application.not_authorized')
    redirect_to(request.referrer || root_path)
  end
end

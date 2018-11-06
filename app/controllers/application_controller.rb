class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :authenticate_core_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_core_user
  end
  private

  def user_not_authorized
    flash[:alert] = t('controllers.application.not_authorized')
    redirect_to(request.referrer || root_path)
  end
end

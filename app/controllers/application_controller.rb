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

  def polymorphic_builder(related_to, polymorphic_type, polymorphic_id)
    if !related_to.blank? && polymorphic_id.blank?
      @klass = polymorphic_type.constantize
      if @klass.reflect_on_association(:person).respond_to?(:name)
        @collection = @klass.joins(:person)
          .where("core_people.first_name Like :name OR core_people.last_name LIKE :name",
            name: related_to).first

        @collection.id if @collection

      elsif @klass.attribute_names.include?("name")
        @collection = @klass.where('name LIKE :name', name: related_to).first
        @collection.id if @collection
      end
    elsif related_to.blank? && !polymorphic_id.blank?
      ""
    else
      polymorphic_id
    end
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

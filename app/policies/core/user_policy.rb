class Core::UserPolicy < ApplicationPolicy

  def show?
    super or (require_owner? and user_is_record?)
  end

  def user_is_record?
    user == record
  end
end

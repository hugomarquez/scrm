class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    if require_owner?
      owner? and can?(:read)
    else
      can?(:read)
    end
  end

  def create?
    can?(:create)
  end

  def new?
    create?
  end

  def update?
    can?(:update)
  end

  def edit?
    update?
  end

  def destroy?
    can?(:delete)
  end

  def role
    user.role.to_sym
  end

  def can?(action)
    return false if user.role == nil
    return true if role == :admin
  end

  def require_owner?
    return false if user.role == nil
  end

  def owner?
    if record.respond_to?(:created_by)
      record.created_by == user
    else
      false
    end
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end # end class Scope
end

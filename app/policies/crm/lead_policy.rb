class Crm::LeadPolicy < ApplicationPolicy
  def clone?
    true
  end

  def convert?
    true
  end
end

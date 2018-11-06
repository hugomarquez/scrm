module Core::Personable
  extend ActiveSupport::Concern
  included do
    has_one :person, dependent: :destroy, as: :personable, class_name:'Core::Person'
    accepts_nested_attributes_for :person,  allow_destroy: true
  end
end

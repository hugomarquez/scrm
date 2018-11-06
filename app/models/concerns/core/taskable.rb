module Core::Taskable
  extend ActiveSupport::Concern
  included do
    has_many :tasks, dependent: :destroy, as: :taskable, class_name:'Crm::Task'
    accepts_nested_attributes_for :tasks, allow_destroy: true
  end
end

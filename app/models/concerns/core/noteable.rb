module Core::Noteable
  extend ActiveSupport::Concern

  included do
    has_many :notes, dependent: :destroy, as: :noteable, class_name:'Core::Note'
    accepts_nested_attributes_for :notes,  allow_destroy: true
  end

end

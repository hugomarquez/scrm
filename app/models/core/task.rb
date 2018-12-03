class Core::Task < ApplicationRecord
  extend FriendlyId

  friendly_id :uid, use: :slugged

  belongs_to :taskable, polymorphic: true, optional: true
  belongs_to :assigned_to, class_name:'Core::User'

  enum status:    [:not_started, :in_progress, :completed, :waiting, :deferred], _suffix: true
  enum priority:  [:high, :normal, :low], _suffix: true

  attr_accessor :related_to, :assigned_to_name

  before_validation :set_assigned_to_name

  validates_presence_of :subject, :status, :priority
  after_initialize :set_default_status, :set_default_priority, :set_random_color, if: :new_record?

  private
  def set_default_status
    self.status ||= :not_started
  end

  def set_default_priority
    self.status ||= :normal
  end

  def set_assigned_to_name
    self.assigned_to_name = self.assigned_to.person.full_name if self.assigned_to
  end

  def set_random_color
    self.color = colors.sample if self.color.nil?
  end

  def colors
    %w( #F44336 #E91E63 #9C27B0 #673AB7 #3F51B5 #2196F3 #03A9F4 #00BCD4 #009688
        #4CAF50 #8BC34A #CDDC39 #FFEB3B #FFC107 #FF9800 #FF5722 #795548 #9E9E9E
        #607D8B
      )
    end
end

class Crm::Lead < ApplicationRecord
  include PublicActivity::Model
  include Core::Personable
  include Core::Noteable
  include Core::Taskable
  extend FriendlyId

  friendly_id :uid, use: :slugged

  tracked only:[:create, :update], owner: :set_tracked_owner
  before_destroy :remove_activity

  belongs_to :created_by, class_name:'Core::User'

  validates_presence_of :company, :status, :number
  after_initialize :set_defaults, if: :new_record?

  enum rating:    [:hot, :warm, :cold], _suffix: true
  enum status:    [:open, :working, :closed, :lost], _suffix: true

  def clone_with_associations
    new_lead = self.dup
    new_lead.build_person(self.person.dup.attributes)
    new_lead
  end

  private
  def set_defaults
    self.number     ||= "L-" + generate_number
    self.rating     ||= :warm
    self.status     ||= :open
  end

  def generate_number
    loop do
      token = rand(1000).to_s
      break token unless Crm::Lead.where(number: token).first
    end
  end

  def set_tracked_owner
    self.created_by
  end

  def remove_activity
    activity = PublicActivity::Activity.find_by(trackable_id: self.id, trackable_type: self.class.to_s, key: "#{self.class.to_s.downcase}.create")
    activity.destroy if activity.present?
    true
  end
end

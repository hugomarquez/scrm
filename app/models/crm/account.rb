class Crm::Account < ApplicationRecord
  include PublicActivity::Model
  include Core::Noteable
  include Core::Taskable
  extend FriendlyId

  tracked only:[:create, :update], owner: :set_tracked_owner
  before_destroy :remove_activity

  friendly_id :uid, use: :slugged

  belongs_to :created_by, class_name:'Core::User'

  has_many :contacts, class_name:'Crm::Contact'
  has_many :deals, class_name:'Crm::Deal'

  validates_presence_of :name, :number

  after_initialize :set_defaults, if: :new_record?

  enum rating:    [:hot, :warm, :cold], _suffix: true
  enum ownership: [:public, :private, :subsidiary, :other], _suffix: true
  enum priority:  [:high, :low, :medium], _suffix: true
  enum employees: [:large, :medium, :small, :micro], _suffix: true

  private

  def set_defaults
    self.number     ||= "A-" + rand(1000).to_s
    self.rating     ||= :warm
    self.ownership  ||= :private
    self.priority   ||= :medium
    self.employees  ||= :medium
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

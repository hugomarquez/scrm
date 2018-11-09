class Crm::Contact < ApplicationRecord
  include PublicActivity::Model
  include Core::Noteable
  include Core::Personable
  include Core::Taskable
  extend FriendlyId

  tracked only:[:create, :update], owner: :set_tracked_owner
  before_destroy :remove_activity

  friendly_id :uid, use: :slugged

  belongs_to :created_by, class_name:'Core::User'
  belongs_to :account, class_name:'Crm::Account', optional: true

  enum level: [:primary, :secondary, :tertiary], _suffix: true
  enum lead_source: [:web, :phone, :referral, :purchased_list, :other], _suffix: true

  attr_accessor :account_label
  before_validation :set_account_label
  validates_presence_of :person, :number
  validates_uniqueness_of :number

  after_initialize :set_defaults, if: :new_record?

  private

  def set_account_label
    self.account_label = self.account.name if self.account
  end

  def set_defaults
    self.number       ||= "C-" + generate_number
    self.level        ||= :primary
    self.lead_source  ||= :web
  end

  def generate_number
    loop do
      token = rand(1000).to_s
      break token unless Crm::Contact.where(number: token).first
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

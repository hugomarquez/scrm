class Crm::Deal < ApplicationRecord
  include PublicActivity::Model
  include Core::Noteable
  include Core::Taskable
  extend FriendlyId

  friendly_id :uid, use: :slugged

  tracked only:[:create, :update], owner: :set_tracked_owner
  before_destroy :remove_activity

  belongs_to :created_by, class_name:'Core::User'
  belongs_to :account, class_name:'Crm::Account', optional: true

  before_save :set_probability
  validates_presence_of :account, :category, :close_at, :name, :number, :stage
  validates_uniqueness_of :number
  after_initialize :set_defaults, if: :new_record?

  enum stage:[
    :prospecting, :qualification, :needs_analysis,
    :value_proposition, :id_decision_makers, :perception_analysis,
    :proposal_quote, :negotiation_review, :closed_won, :closed_lost
  ], _suffix: true

  enum category: [:existing_customer, :new_customer ], _suffix: true
  enum lead_source: [:web, :phone, :referral, :purchased_list, :other], _suffix: true

  attr_accessor :account_label
  before_validation :set_account_label

  def self.by_stage
    @deals = Crm::Deal.select("probability, stage, count(stage) as total_stage").group(:stage).map do |d|
      {
        probability: d.probability,
        stage: I18n.t("activerecord.attributes.crm/deal.stages_options.#{d.stage}"),
        total_stage: d.total_stage
      }
    end
  end

  def self.amount_v_expected
    @deals = Crm::Deal.select("stage, sum(amount) as amount, sum(expected_revenue) as expected_amount, count(stage) as total_stage").group(:stage).map do |d|
      {
        stage: I18n.t("activerecord.attributes.crm/deal.stages_options.#{d.stage}"),
        amount: d.amount,
        expected_revenue: d.expected_amount,
        total_stage: d.total_stage,
      }
    end
    @deals.push({
      labels:{
        amount: I18n.t("activerecord.attributes.crm/deal.amount"),
        expected_revenue: I18n.t("activerecord.attributes.crm/deal.expected_revenue")
      }
    })
  end

  private
  def stage_probability
    case self.stage
    when 'prospecting' then 10
    when 'qualification' then 20
    when 'needs_analysis' then 30
    when 'value_proposition' then 40
    when 'id_decision_makers' then 50
    when 'perception_analysis' then 60
    when 'proposal_quote' then 70
    when 'negotiation_review' then 80
    when 'closed_won' then 100
    when 'closed_lost' then 0
    end
  end

  def set_probability
    self.probability = stage_probability
  end

  def set_account_label
    self.account_label = self.account.name if self.account
  end

  def set_tracked_owner
    self.created_by
  end

  def set_defaults
    self.number       ||= "D-" + generate_number
    self.stage        ||= :prospecting
    self.category     ||= :new_customer
    self.lead_source  ||= :web
  end

  def generate_number
    loop do
      token = rand(1000).to_s
      break token unless Crm::Deal.where(number: token).first
    end
  end

  def remove_activity
    activity = PublicActivity::Activity.find_by(trackable_id: self.id, trackable_type: self.class.to_s, key: "#{self.class.to_s.downcase}.create")
    activity.destroy if activity.present?
    true
  end
end

class Core::Organization < ApplicationRecord
  extend FriendlyId

  friendly_id :uid, use: :slugged
  has_many :members, class_name:'Core::User'
  belongs_to :owner, class_name:'Core::User', optional: true

  accepts_nested_attributes_for :members
  accepts_nested_attributes_for :owner
end

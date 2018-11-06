class Core::Note < ApplicationRecord
  extend FriendlyId
  friendly_id :uid, use: :slugged

  belongs_to :noteable, polymorphic: true, optional: true
  belongs_to  :created_by, class_name:'Core::User'

  attr_accessor :related_to
end

class Core::Task < ApplicationRecord
  extend FriendlyId

  friendly_id :uid, use: :slugged
  
  belongs_to :taskable, polymorphic: true, optional: true
  belongs_to :assigned_to, class_name:'Core::User'
end

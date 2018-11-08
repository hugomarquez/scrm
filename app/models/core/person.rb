class Core::Person < ApplicationRecord
  extend FriendlyId

  friendly_id :uid, use: :slugged
  belongs_to :personable, polymorphic: true, optional: true

  validates_presence_of :first_name, :last_name

  def full_name
    if self.first_name && self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      ""
    end
  end
end

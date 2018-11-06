class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :recent, -> { where(created_at: 5.days.ago.. Time.current).order(created_at: :desc) }
  
end

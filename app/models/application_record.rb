class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :recent, -> { where(created_at: 5.days.ago.. Time.current).order(created_at: :desc) }

  def uid
    slug || SecureRandom.urlsafe_base64(5, false)
  end

end

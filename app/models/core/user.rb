class Core::User < ApplicationRecord
  include Core::Personable
  extend FriendlyId

  friendly_id :uid, use: :slugged

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role:  [:user, :admin, :account_owner]

  validates :authentication_token, uniqueness: true
  before_save :ensure_authentication_token!

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Core::User.where(authentication_token: token).first
    end
  end
end

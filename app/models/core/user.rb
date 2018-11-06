class Core::User < ApplicationRecord
  include Core::Personable
  extend FriendlyId

  friendly_id :uid, use: :slugged

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization, class_name:'Core::Organization', inverse_of: :members, optional: true

  validates :authentication_token, uniqueness: true
  before_save :ensure_authentication_token!

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

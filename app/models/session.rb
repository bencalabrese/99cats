class Session < ActiveRecord::Base
  validates :user_id, :session_token, presence: true
  validates :session_token, uniqueness: true

  after_initialize :ensure_session_token

  belongs_to :user

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  attr_reader :password

  has_many :cats
  has_many :requests, class_name: :CatRentalRequest
  has_many :sessions

  validates :user_name, :password_digest, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  def self.find_by_credentials(user_name, password)
    user = self.find_by_user_name(user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(@password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end

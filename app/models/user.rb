class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  before_save { login.downcase! }
  
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}
  validates :login, presence: true, length: {maximum: 255}, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, presence: true
  
  has_secure_password
end

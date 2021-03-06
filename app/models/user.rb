# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  login           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  remember_digest :string
#  roles           :string(2)        default("U")
#
# Indexes
#
#  index_users_on_login  (login) UNIQUE
#

class User < ApplicationRecord
  include Adauth::Rails::ModelBridge
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  Roles = {
    "U" => "user",
    "A" => "admin"
  }
  
  attr_accessor :remember_token
  
  before_save { login.downcase! }
  
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}
  validates :login, presence: true, length: {maximum: 255}, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  has_secure_password
  
  AdauthMappings = {
        :login => :login,
        :email => :email
  }
  
  AdauthSearchField = [:login, :login]
  
  # Returns boolean if user is admin
  def admin?
    roles.match(/A/)
  end
  
  # Returns list of roles as string
  def roles_to_s
    roles.split("").map {|ch| Roles[ch]}.join(",")  
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  
    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  
    # Checks both authentication methods (local and AD)
    def authenticate(login,password)
      user = User.find_by(login: login.downcase)
      update_adauth_cfg(login,password)
      # first try local authentication, nil password means AD account
      if (user && !user.password_digest.nil? && user.authenticate(password))
        user
      # then AD authentication
      elsif auser = Adauth.authenticate(login,password)
        User.return_and_create_from_adauth(auser)
      else
        false
      end
    end
    
    # Override Adauth finder to allow some further actions
    def return_and_create_from_adauth(ad_model)
      user = super(ad_model)
      # some AD are emailless, create dummy as our app requires it
      if user.email.blank?
        user.email = "unknown@unknown.com"
      end
      
      # create name
      begin
        user.name = "#{ad_model.first_name} #{ad_model.last_name}"
      rescue NoMethodError
        user.name=ad_model.login
      end
      
      user.save(validate: false)
      user
    end
  end
end

class User
  class << self
    private
    def update_adauth_cfg(login,password)
      Adauth.configure do |c|
        c.domain = AppConfig.get("ad_domain") if !AppConfig.get("ad_domain").nil?
        c.server = AppConfig.get("ad_controller") if !AppConfig.get("ad_controller").nil?
        c.base = AppConfig.get("ad_ldap_base") if !AppConfig.get("ad_ldap_base").nil?
        c.allowed_groups = AppConfig.get("ad_allowed_groups").split(",") if !AppConfig.get("ad_allowed_groups").nil?
        c.query_user=login
        c.query_password=password
      end
    end
  end
end


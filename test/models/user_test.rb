require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@email.com", login: "user",
                     password: "foobar", password_confirmation: "foobar")
    @local_user = users(:tomas)
    @nonadmin = users(:archer)
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "login should be present" do
    @user.login = "     "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "login should not be too long" do
    @user.login = "a" * 256
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "login should be unique" do
    duplicate_user = @user.dup
    duplicate_user.login = @user.login.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "login should be saved as lower-case" do
    mixed_case_login = "User"
    @user.login = mixed_case_login
    @user.save
    assert_equal mixed_case_login.downcase, @user.reload.login
  end
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
  
  test "User.authenticate with valid local account" do
    assert User.authenticate(@local_user.login,"password")
  end
  
  test "User.authenticate with invalid local account and invalid AD account" do
    Adauth.stub :authenticate, false do
      assert_not User.authenticate(@local_user.login,"invalid_password")
    end
  end
  
  test "User.authenticate with valid AD account + AD to User transformation" do
    ad_model = OpenStruct.new(login:'new_ad_login',email:'email@email.com',first_name:"AD",last_name:'Login')
    user = nil
    Adauth.stub :authenticate, ad_model do
      assert_difference 'User.count', 1 do
        assert user = User.authenticate(ad_model.login,"valid_AD_password")
      end
      assert_equal user.login, ad_model.login
      assert_equal user.email, ad_model.email
      assert_equal user.name, "#{ad_model.first_name} #{ad_model.last_name}"
    end
    # AD can loggin again + empty email handling
    ad_model = OpenStruct.new(login:'new_ad_login',email:'',first_name:"AD",last_name:'Login')
    Adauth.stub :authenticate, ad_model do
      assert_difference 'User.count', 0 do
        assert user = User.authenticate(ad_model.login,"valid_AD_password")
      end
      assert_equal user.login, ad_model.login
      assert_equal user.email, "unknown@unknown.com"
      assert_equal user.name, "#{ad_model.first_name} #{ad_model.last_name}"
    end
  end
  
  test "User.authenticate calls update_adauth_cfg " do
    @called = 0
    ad_model = OpenStruct.new(login:'new_ad_login',email:'email@email.com',first_name:"AD",last_name:'Login')
    
    User.stub :update_adauth_cfg, Proc.new { @called+=1 } do
      Adauth.stub :authenticate, ad_model do
        User.authenticate(ad_model.login,"valid_AD_password")
      end
    end
    assert_equal 1, @called
  end
  
  test "update_adauth_cfg updated Adauth config" do    
    # entry adauth setting
    Adauth.configure do |c|
      c.domain = "domain"
      c.server = "server"
      c.base = "base"
      c.allowed_groups = "allowed_groups"
      c.query_user="user"
      c.query_password="password"
    end
    # initiate config
    old_domain = AppConfig.get "ad_domain"
    old_server = AppConfig.get "ad_controller"
    old_base = AppConfig.get "ad_ldap_base"
    old_allowed_groups = AppConfig.get "ad_allowed_groups"
    AppConfig.set "ad_domain", "new_domain"
    AppConfig.set "ad_controller", "new_server"
    AppConfig.set "ad_ldap_base", "new_base"
    #AppConfig.set "ad_allowed_groups", "new_allowed_groups"
    
    # actual test
    User.send :update_adauth_cfg, @local_user.login,@local_user.password
    ad_config = Adauth.instance_variable_get(:@config)
    assert_equal "new_domain", ad_config.domain
    assert_equal "new_server", ad_config.server
    assert_equal "new_base", ad_config.base
    assert_equal [], ad_config.allowed_groups
    assert_equal @local_user.login, ad_config.query_user
    assert_equal @local_user.password, ad_config.query_password
     
    # cfg restore
    AppConfig.set "ad_domain", old_domain
    AppConfig.set "ad_controller", old_server
    AppConfig.set "ad_ldap_base", old_base
  end

  test "User Roles hash" do
    assert User::Roles
    assert_equal "user", User::Roles["U"]
    assert_equal "admin", User::Roles["A"]
  end
  
  test "New User has only user role by default" do
    assert_equal "U", @user.roles
  end
  
  test "admin? method" do
    assert @local_user.admin?
  end
  
  test "full text roles" do
    assert_equal "admin", @local_user.roles_to_s 
    assert_equal "user", @nonadmin.roles_to_s 
  end
end
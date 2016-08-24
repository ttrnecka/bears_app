require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
    @old_domain = AppConfig.get "ad_domain"
    @old_server = AppConfig.get "ad_controller"
    @old_base = AppConfig.get "ad_ldap_base"
    #put test data
    AppConfig.set "ad_domain", "test_domain"
    AppConfig.set "ad_controller", "test_server"
    AppConfig.set "ad_ldap_base", "test_base"
  end
  
  def teardown
    AppConfig.set "ad_domain", @old_domain
    AppConfig.set "ad_controller", @old_server
    AppConfig.set "ad_ldap_base", @old_base
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { login: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select "div.alert", {text: /Invalid/}
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { login:    @user.login,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_redirected_to login_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    # Simulate a user clicking logout in a second window.
    delete logout_path
  end
  
  test "loading root page when not logged in will redirect to signin" do
    get root_url
    assert_redirected_to login_path
  end
  
   test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
  test "friendly forwarding forgets forward path after first forwarding" do
    get edit_user_path(@user)
    follow_redirect!
    log_in_as @user
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
  end
  
  test "redirects to root_url if opens login_path when logged in" do
    log_in_as @user
    get login_path
    assert_redirected_to root_url
  end
  
  test "redirects to root_url if opens signup_path when logged in" do
    log_in_as @user
    get signup_path
    assert_redirected_to root_url
    post signup_path
    assert_redirected_to root_url
  end
  
  test "shows flash message when AD authentication does not work" do
    log_in_as users(:ad_user)
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
    assert_select "div.alert", {text: /There are problems with AD authentication/}
  end
end

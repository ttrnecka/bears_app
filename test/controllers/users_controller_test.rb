require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign Up")
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email,
                                              login: @user.login } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect edit when logged as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect edit when logged as admin editing different user" do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # update
  test "should redirect update when logged as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email,
                                              login: @user.login } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should not redirect update when logged as admin" do
    log_in_as(@user)
    patch user_path(@other_user), params: { user: { name: @other_user.name,
                                              email: @other_user.email,
                                              login: @other_user.login } }
    assert_redirected_to users_path
    follow_redirect!
    assert_not flash.empty?
  end
  
  test "should allow admin to promote/demote user" do
    log_in_as(@user)
    # promoting
    patch user_path(@other_user), params: { user: { roles: "A" } }
    assert_redirected_to users_path
    follow_redirect!
    assert_not flash.empty?
    assert_equal "A", @other_user.reload.roles
    # demoting
    patch user_path(@other_user), params: { user: { roles: "U" } }
    assert_redirected_to users_path
    follow_redirect!
    assert_not flash.empty?
    assert_equal "U", @other_user.reload.roles
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  
  test "should not allow the roles attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            roles: "A" } }
    assert_not @other_user.reload.admin?
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when admin tries to delete himself" do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end

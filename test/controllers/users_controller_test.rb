require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
    @other_user = users(:archer)
  end
  
  # Index
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign Up")
  end
  
  test "should get index when logged in as admin using json" do
    log_in_as @user
    get users_path, as: :json, xhr: true
    assert_equal User.all.to_json, @response.body
    assert_equal "application/json", @response.content_type
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should disable turbolinks cache for index" do
    log_in_as(@user)
    get users_path
    assert_select 'meta[name="turbolinks-cache-control"][content="no-cache"]', 1
  end
  
  # Edit
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
  
  # Update
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
  
  test "should allow admin to promote/demote user - json,xhr" do
    log_in_as(@user)
    # promoting
    patch user_path(@other_user), params: { user: { roles: "A" } }, as: :json, xhr: true
    assert_response :success
    assert_equal "A", @other_user.reload.roles
    refute_nil JSON.parse(@response.body)["id"]
    # demoting
    patch user_path(@other_user), params: { user: { roles: "U" } }, as: :json, xhr: true
    assert_response :success
    assert_equal "U", @other_user.reload.roles
    refute_nil JSON.parse(@response.body)["id"]
  end
  
  test "should not allow non-admin to promote/demote user - json,xhr" do
    log_in_as(@other_user)
    # promoting
    patch user_path(@user), params: { user: { roles: "A" } }, as: :json, xhr: true
    assert_response :unauthorized
    # demoting
    patch user_path(@user), params: { user: { roles: "U" } }, as: :json, xhr: true
    assert_response :unauthorized
  end
  
  test "should allow user to change profile" do
    log_in_as @other_user
    patch user_path(@other_user), params: { user: { name: "changed_name", password:"testing", password_confirmation:"testing" } }
    assert_redirected_to user_path(@other_user)
    assert_equal "changed_name", @other_user.reload.name
    assert @other_user.authenticate('testing')
  end
  
  test "should not allow user to change his role" do
    log_in_as @other_user
    patch user_path(@other_user), params: { user: { roles: "A" } }
    assert_redirected_to user_path(@other_user)
    assert_equal "U", @other_user.reload.roles 
  end
  
  test "should allow admin to change his password" do
    log_in_as @user
    patch user_path(@user), params: { user: { name: "changed_name", password:"testing", password_confirmation:"testing" } }
    assert_redirected_to user_path(@user)
    assert_equal "changed_name", @user.reload.name
    assert @user.authenticate('testing')
  end
  
  test "should allow admin to change profile" do
    log_in_as @user
    patch user_path(@user), params: { user: { name: "changed_name" } }
    assert_redirected_to user_path(@user)
    assert_equal "changed_name", @user.reload.name 
  end
  
  test "should not allow the roles attribute to be edited by user" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            roles: "A" } }
    assert_not @other_user.reload.admin?
  end
  
  # Destroy
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
  
  test "should destroy user as admin using json" do
    log_in_as @user
    assert_difference 'User.count',-1 do
      delete user_path(@other_user), as: :json
    end
    assert_response :success
  end

  test "should unauthorize destroy when logged as user using json" do
    log_in_as @other_user
    assert_no_difference 'User.count' do
      delete user_path(@other_user), as: :json
    end
    assert_response :unauthorized
  end
    
  test "should unautorize destroy when not logged in using json" do
    delete user_path(@other_user),  as: :json
    assert_response :unauthorized
  end
end
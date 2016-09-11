require 'test_helper'

module Admin
  class CredentialsControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:tomas)
      @other_user = users(:archer)
      @cred = admin_credentials(:bears_global)
    end
    
    test "should redirect index when not logged in" do
      get admin_credentials_path
      assert_redirected_to login_url
    end
    
    test "should get index when logged in as admin" do
      log_in_as @user
      get admin_credentials_path
      assert_response :success
      assert_select "title", full_title("Credentials")
      refute_nil assigns(:credentials)
    end
    
    test "should disable turbolinks cache for index" do
      log_in_as(@user)
      get admin_credentials_path
      assert_select 'meta[name="turbolinks-cache-control"][content="no-cache"]', 1
    end
    
    test "should be redirected the index when logged in as used" do
      log_in_as @other_user
      get admin_credentials_path
      assert_redirected_to root_url
    end
  end
end

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
    end
    
    test "should get index when logged in as admin using xhr" do
      log_in_as @user
      get admin_credentials_path, xhr: true, as: :json
      assert_equal admin_credentials(:bears_global, :bears_local).to_json, @response.body
      assert_equal "application/json", @response.content_type
    end
    
    test "should disable turbolinks cache for index" do
      log_in_as(@user)
      get admin_credentials_path
      assert_select 'meta[name="turbolinks-cache-control"][content="no-cache"]', 1
    end
    
    test "should be redirected the index when logged in as user" do
      log_in_as @other_user
      get admin_credentials_path
      assert_redirected_to root_url
    end
    
    test "should destroy credential as admin using json" do
      log_in_as @user
      assert_difference 'Admin::Credential.count',-1 do
        delete admin_credential_path(@cred), xhr: true, as: :json
      end
      assert_response :success
    end
    
    test "should redirect destroy when logged as user" do
      log_in_as @other_user
      assert_no_difference 'Admin::Credential.count' do
        delete admin_credential_path(@cred), xhr: true, as: :json
      end
      assert_response :unauthorized
    end
    
    test "should redirect destroy when not logged in" do
      delete admin_credential_path(@cred), xhr: true, as: :json
      assert_response :unauthorized
    end
    
    test "should redirect after destroy when used html format" do
      log_in_as @user
      assert_difference 'Admin::Credential.count',-1 do
        delete admin_credential_path(@cred)
      end
      assert_redirected_to admin_credentials_url
    end
  end
end

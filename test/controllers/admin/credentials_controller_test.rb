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
    
    test "should get index when logged in as admin using json" do
      log_in_as @user
      get admin_credentials_path, as: :json
      assert_equal admin_credentials(:bears_global, :bears_local).to_json, @response.body
      assert_equal "application/json", @response.content_type
    end
    
    test "should disable turbolinks cache for index" do
      log_in_as(@user)
      get admin_credentials_path
      assert_select 'meta[name="turbolinks-cache-control"][content="no-cache"]', 1
    end
    
    test "should redirect the index when logged in as user" do
      log_in_as @other_user
      get admin_credentials_path
      assert_redirected_to root_url
    end
    
    test "should destroy credential as admin using json" do
      log_in_as @user
      assert_difference 'Admin::Credential.count',-1 do
        delete admin_credential_path(@cred), as: :json
      end
      assert_response :success
    end
    
    
    test "should unauthorize destroy when logged as user using json" do
      log_in_as @other_user
      assert_no_difference 'Admin::Credential.count' do
        delete admin_credential_path(@cred), as: :json
      end
      assert_response :unauthorized
    end
    
    test "should redirect destroy when logged as user using html" do
      log_in_as @other_user
      assert_no_difference 'Admin::Credential.count' do
        delete admin_credential_path(@cred)
      end
      assert_redirected_to root_url
    end
    
    test "should unautorize destroy when not logged in using json" do
      delete admin_credential_path(@cred),  as: :json
      assert_response :unauthorized
    end
    
    test "should redirect destroy when not logged in using html" do
      delete admin_credential_path(@cred)
      assert_redirected_to login_url
    end
    
    test "should get unauthorized on json update when not logged in" do
      patch admin_credential_path(@cred), params: { description: @cred.description,
                                                account: @cred.account } , as: :json
      assert_response :unauthorized
    end
    
    test "should get redirected on html update when not logged in" do
      patch admin_credential_path(@cred), params: { description: @cred.description,
                                                account: @cred.account }
      assert_redirected_to login_url
    end
    
    test "should get unauthorized on json update when logged in as user" do
      log_in_as @other_user
      patch admin_credential_path(@cred), params: { description: @cred.description,
                                                account: @cred.account }, as: :json
      assert_response :unauthorized
    end
      
    test "should allow admin to update credential - json" do
      log_in_as(@user)
      patch admin_credential_path(@cred), params: { description: @cred.description,
                                                account: "test_account" }, as: :json
      assert_response :success
      assert_equal "test_account", @cred.reload.account
      refute_nil JSON.parse(@response.body)["id"]
    end
    
    test "should return errors and 422 if admin cannot update credential - json" do
      log_in_as(@user)
      patch admin_credential_path(@cred), params: { description: @cred.description,
                                                account: "test_account", password:"password",password_confirmation:"pswd" }, as: :json
      assert_response 422
      assert_equal "Password confirmation doesn't match Password", JSON.parse(@response.body)["errors"][0]
    end
  
    test "should redirect search by user that is not logged_in" do
      get search_admin_credentials_path(description: "test"), as: :json
      assert_redirected_to login_url
    end
    
    test "should get unauthorized on json search when logged in as user" do
      log_in_as(@other_user)
      get search_admin_credentials_path, params: {description: "test"}
      assert_redirected_to root_url
    end
    
    test "should retunr list of found credetials for admin" do
      log_in_as @user
      get search_admin_credentials_path, params: {description: "Bears account for VPC UK"}, xhr:true
      assert_response :success
      assert_equal JSON.parse([@cred].to_json), JSON.parse(@response.body)
    end
  end
end

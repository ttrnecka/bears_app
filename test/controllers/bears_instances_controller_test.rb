require 'test_helper'

class BearsInstancesControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:tomas)
      @other_user = users(:archer)
    end
    
    # Index
    test "should redirect index when not logged in" do
      get bears_instances_path
      assert_redirected_to login_url
    end
    
    test "should redirect index when usign html format" do
      log_in_as @user
      get bears_instances_path
      assert_redirected_to root_url
    end
    
    test "should get index when logged in as admin using json" do
      log_in_as @user
      get bears_instances_path, as: :json
      assert_equal BearsInstance.all.to_json, @response.body
      assert_equal "application/json", @response.content_type
    end
    
    test "should get index when logged in as user using json" do
      log_in_as @other_user
      get bears_instances_path, as: :json
      assert_equal BearsInstance.all.to_json, @response.body
      assert_equal "application/json", @response.content_type
    end   
end


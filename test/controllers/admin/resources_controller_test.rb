require 'test_helper'

module Admin
  class ResourcesControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:tomas)
      @other_user = users(:archer)
      @resource = admin_resources(:webapi)
      @new_resource = Resource.new(address: "10.200.0.134", protocol: "ssh",
                       credential_id: Admin::Credential.first.id, bears_instance_id: BearsInstance.first.id)
    end
    
    # Index
    test "should redirect index when not logged in" do
      get admin_resources_path
      assert_redirected_to login_url
    end
    
    test "should get index when logged in as admin" do
      log_in_as @user
      get admin_resources_path
      assert_response :success
      assert_select "title", full_title("Resources - Discovery")
    end
    
    test "should get index when logged in as admin using json" do
      log_in_as @user
      get admin_resources_path, as: :json
      assert_equal Admin::Resource.all.to_json, @response.body
      assert_equal "application/json", @response.content_type
    end
    
    test "should disable turbolinks cache for index" do
      log_in_as(@user)
      get admin_resources_path
      assert_select 'meta[name="turbolinks-cache-control"][content="no-cache"]', 1
    end
    
    test "should redirect the index when logged in as user" do
      log_in_as @other_user
      get admin_resources_path
      assert_redirected_to root_url
    end
    
    # Destroy
    test "should destroy resource as admin using json" do
      log_in_as @user
      assert_difference 'Admin::Resource.count',-1 do
        delete admin_resource_path(@resource), as: :json
      end
      assert_response :success
    end
    
    
    test "should unauthorize destroy when logged as user using json" do
      log_in_as @other_user
      assert_no_difference 'Admin::Resource.count' do
        delete admin_resource_path(@resource), as: :json
      end
      assert_response :unauthorized
    end
    
    test "should redirect destroy when logged as user using html" do
      log_in_as @other_user
      assert_no_difference 'Admin::Resource.count' do
        delete admin_resource_path(@resource)
      end
      assert_redirected_to root_url
    end
    
    test "should unautorize destroy when not logged in using json" do
      delete admin_resource_path(@resource),  as: :json
      assert_response :unauthorized
    end
    
    test "should redirect destroy when not logged in using html" do
      delete admin_resource_path(@resource)
      assert_redirected_to login_url
    end
    # Update
    test "should get unauthorized on json update when not logged in" do
      patch admin_resource_path(@resource), params: { address: @resource.address,
                                                protocol: @resource.protocol } , as: :json
      assert_response :unauthorized
    end
    
    test "should get redirected on html update when not logged in" do
      patch admin_resource_path(@resource), params: { address: @resource.address,
                                                protocol: @resource.protocol }
      assert_redirected_to login_url
    end
    
    test "should get unauthorized on json update when logged in as user" do
      log_in_as @other_user
      patch admin_resource_path(@resource), params: { address: @resource.address,
                                                protocol: @resource.protocol } , as: :json
      assert_response :unauthorized
    end
      
    test "should allow admin to update credential - json" do
      log_in_as(@user)
      patch admin_resource_path(@resource), params: { address: @resource.address,
                                                protocol: "ssh" }, as: :json
      assert_response :success
      assert_equal "ssh", @resource.reload.protocol
      refute_nil JSON.parse(@response.body)["id"]
    end
    
    test "should return errors and 422 if admin cannot update resource - json" do
      log_in_as(@user)
      patch admin_resource_path(@resource), params: { address: @resource.address,
                                                protocol: "invalid" } , as: :json
      assert_response 422
      assert_equal "Protocol must be from the list: #{Admin::Resource::PROTOCOLS.join(',')}", JSON.parse(@response.body)["errors"][0]
    end
    
    # Create
    test "should get unauthorized on json create when not logged in" do
      post admin_resources_path, params: { address: @new_resource.address,
                                                protocol: @new_resource.protocol, credential_id: @new_resource.credential_id, 
                                                bears_instance_id: @new_resource.bears_instance_id  } , as: :json, xhr:true
      assert_response :unauthorized
    end
    
    test "should get redirected on html create when not logged in" do
      post admin_resources_path, params: { address: @new_resource.address,
                                                protocol: @new_resource.protocol, credential_id: @new_resource.credential_id, 
                                                bears_instance_id: @new_resource.bears_instance_id  }
      assert_redirected_to login_url
    end
    
    test "should get unauthorized on json create when logged in as user" do
      log_in_as @other_user
      post admin_resources_path, params: { address: @new_resource.address,
                                                protocol: @new_resource.protocol, credential_id: @new_resource.credential_id, 
                                                bears_instance_id: @new_resource.bears_instance_id  } , as: :json, xhr:true
      assert_response :unauthorized
    end
      
    test "should allow admin to create resource - json" do
      log_in_as(@user)
      post admin_resources_path, params: { address: @new_resource.address,
                                                protocol: @new_resource.protocol, credential_id: @new_resource.credential_id, 
                                                bears_instance_id: @new_resource.bears_instance_id  } , as: :json, xhr:true
      assert_response :success
      id = JSON.parse(@response.body)["id"]
      refute_nil id
      assert_equal "10.200.0.134", Admin::Resource.find(id).address
    end
    
    test "should return errors and 422 if admin cannot create resource - json" do
      log_in_as(@user)
      post admin_resources_path, params: { address: @new_resource.address,
                                                protocol: "invalid", credential_id: @new_resource.credential_id, 
                                                bears_instance_id: @new_resource.bears_instance_id  } , as: :json, xhr:true
      assert_response 422
      assert_equal "Protocol must be from the list: #{Admin::Resource::PROTOCOLS.join(',')}", JSON.parse(@response.body)["errors"][0]
    end
  end
end

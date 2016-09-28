require 'test_helper'

module Admin
  class ResourceTest < ActiveSupport::TestCase
    def setup
      @resource = Resource.new(address: "10.200.0.134", protocol: "ssh",
                       credential_id: Admin::Credential.first.id, bears_instance_id: BearsInstance.first.id)
      @gresource = admin_resources(:webapi)
      @lresource = admin_resources(:local_3par)
    end
    
     test "should be valid" do
      assert @resource.valid?
    end
    
    test "address should be present" do
      @resource.address = "     "
      assert_not @resource.valid?
    end
    
    test "address shold be IP, FQDN or valid web address" do
      @resource.address = "$ththt"
      assert_not @resource.valid?
      @resource.address = "test.hpe.com"
      assert @resource.valid?
      @resource.address = "test-hpe-com"
      assert_not @resource.valid?
      @resource.address = "http://test.hpe.com/api"
      assert_not @resource.valid?
    end
    
    test "protocol should be present" do
      @resource.protocol = "     "
      assert_not @resource.valid?
    end
    
    test "protocol should be from the list" do
      @resource.protocol = "nonsense"
      assert_not @resource.valid?
    end
    
    test "credential should not be nil" do
      @resource.credential = nil
      assert_not @resource.valid?
    end
  end
end

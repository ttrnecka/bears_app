require 'test_helper'

class StorageArraysControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:archer)
  end
  
  test "should redirect index when not logged in" do
    get storage_arrays_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should not redirect index when logged in" do
    log_in_as(@user)
    get storage_arrays_path
    assert_template "storage_arrays/index"
    assert flash.empty?
    assert_select "title", full_title("Arrays")
  end
end

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
   def setup
    @another_admin     = users(:tomas)
    @admin     = users(:admin)
    @non_admin = users(:archer)
  end
  
  test "index as admin including delete links" do
    log_in_as @admin
    get users_path
    assert_template "users/index"
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_redirected_to root_url
  end
end

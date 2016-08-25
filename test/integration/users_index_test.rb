require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
   def setup
    @admin     = users(:tomas)
    @non_admin = users(:archer)
  end
  
  test "index as admin including delete links" do
    log_in_as @admin
    get users_path
    assert_template "users/index"
    User.all.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      if user == @admin
        assert_select 'a[href=?]', user_path(user), text: "Delete", count: 0
        assert_select 'a[href=?]', edit_user_path(user), text: "Edit", count: 0
      else
        assert_select 'a[href=?]', user_path(user), text: "Delete"
        assert_select 'a[href=?]', edit_user_path(user), text: "Edit"
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Delete', count: 0
    assert_select 'a', text: 'Edit', count: 0
  end
end

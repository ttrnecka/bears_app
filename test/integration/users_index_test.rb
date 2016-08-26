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
    User.all.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      if user == @admin
        assert_select 'a[href=?]', user_path(user), text: "Delete", count: 0
        assert_select 'a[data-method=patch][href=?]', user_path(user,"user[roles]" => "U"), text: "Demote to user", count: 0
        assert_select 'a[data-method=patch][href=?]', user_path(user,"user[roles]" => "A"), text: "Promote to admin", count: 0
      else
        assert_select 'a[href=?]', user_path(user), text: "Delete"
        if user.admin?
          assert_select 'a[data-method=patch][href=?]', user_path(user,"user[roles]" => "U"), text: "Demote to user"
        else
          assert_select 'a[data-method=patch][href=?]', user_path(user,"user[roles]" => "A"), text: "Promote to admin"
        end
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_redirected_to root_url
  end
end

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
   def setup
    @user = users(:tomas)
  end
  
  test "user index" do
    log_in_as @user
    get users_path
    assert_template "users/index"
    User.all.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end

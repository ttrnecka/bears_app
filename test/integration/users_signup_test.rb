require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
   test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         login: "",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         login: 'example_user',
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not flash.empty?
  end
end

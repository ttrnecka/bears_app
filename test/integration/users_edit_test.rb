require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
  end
  
  test "unsuccessfull edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: {user: { name: "",
                                            email: "foo@invalid",
                                            login: "",
                                            password:               "foo",
                                            password_confirmation:  "bar"}}
    assert_template "users/edit"
  end
  
  test "successfull edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = 'Foor Bar'
    login = 'foobar'
    email = "foo@bar.com"
    patch user_path(@user), params: {user: { name: name,
                                            email: email,
                                            login: login,
                                            password:               "",
                                            password_confirmation:  ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
    assert_equal login, @user.login
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    login = "foobar"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              login: login,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
    assert_equal login, @user.login
  end
end

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
  end
    
  test "layout links when logged" do
    get root_path
    assert_redirected_to login_path
    log_in_as @user
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", news_path
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[id=?]", "menu_dashboard", count: 1, title: "Dashboard"
    assert_select "a[id=?]", "menu_configuration", count: 1, title: "Configuration"
    assert_select "a[id=?]", "menu_users", count: 1, title: "Users"
    get about_path
    assert_select "title", full_title("About")
    get help_path
    assert_select "title", full_title("Help")
  end
  
  test "layout links when logged out" do
    get root_path
    follow_redirect!
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", news_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path,  count: 0
    assert_select "a[id=?]", "menu_dashboard", count: 0, title: "Dashboard"
    assert_select "a[id=?]", "menu_configuration", count: 0, title: "Configuration"
    assert_select "a[id=?]", "menu_users", count: 0, title: "Users"
  end
end


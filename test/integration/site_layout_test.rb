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
    assert_select "a[href=?]", help_path, title: "Help"
    assert_select "a[href=?]", about_path, title: "About"
    assert_select "a[href=?]", news_path, title: "News"
    assert_select "a[href=?]", logout_path, title: "Logout"
    assert_select "a[href=?]", user_path(@user), title: "Users"
    assert_select "a[href=?]", edit_user_path(@user), title: "Settings"
    assert_select "a[href=?]", users_path, title: "Users"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[id=?]", "menu_dashboard", count: 1, title: "Dashboard"
    assert_select "a[id=?]", "menu_configuration", count: 1, title: "Configuration"
    assert_select "a[id=?]", "menu_users", count: 1, title: "Users"
    assert_select "a[id=?][href=?]", "menu_resources","#", count: 1, title: "Resources"
    assert_select "a[id=?]", "menu_arrays", count: 1, title: "Arrays"
    assert_select "a[id=?][href=?]", "menu_arrays_all",storage_arrays_path, count: 1, title: "ALL"
    assert_select "a[id=?][href=?]", "menu_arrays_3par",storage_arrays_path(array_type: "3PAR"), count: 1, title: "3PAR"
    assert_select "a[id=?][href=?]", "menu_arrays_eva",storage_arrays_path(array_type: "EVA"), count: 1, title: "EVA"
    get about_path
    assert_select "title", full_title("About")
    get help_path
    assert_select "title", full_title("Help")
  end
  
  test "layout links when logged out" do
    get root_path
    follow_redirect!
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", help_path, title: "Help"
    assert_select "a[href=?]", about_path, title: "About"
    assert_select "a[href=?]", news_path, title: "News"
    assert_select "a[href=?]", login_path, title: "Log in"
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path,  count: 0
    assert_select "a[id=?]", "menu_dashboard", count: 0, title: "Dashboard"
    assert_select "a[id=?]", "menu_configuration", count: 0, title: "Configuration"
    assert_select "a[id=?]", "menu_users", count: 0, title: "Users"
    assert_select "a[id=?][href=?]", "menu_resources","#", count: 0, title: "Resources"
    assert_select "a[id=?]", "menu_arrays", count: 0, title: "Arrays"
    assert_select "a[id=?][href=?]", "menu_arrays_all",storage_arrays_path, count: 0, title: "ALL"
    assert_select "a[id=?][href=?]", "menu_arrays_3par",storage_arrays_path(array_type: "3PAR"), count: 0, title: "3PAR"
    assert_select "a[id=?][href=?]", "menu_arrays_eva",storage_arrays_path(array_type: "EVA"), count: 0, title: "EVA"
    
  end
end


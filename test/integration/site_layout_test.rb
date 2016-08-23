require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
  end
    
  test "layout links when logged" do
    get root_path
    assert_redirected_to login_path
    post login_path, params: { session: { login:    @user.login,
                                          password: 'password' } }
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
    get about_path
    assert_select "title", full_title("About")
    get help_path
    assert_select "title", full_title("Help")
  end
end


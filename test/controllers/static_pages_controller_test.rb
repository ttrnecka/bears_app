require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", full_title("About")
  end

  test "should get home" do
    get root_path
    assert_response :redirect
    assert_redirected_to login_path
    follow_redirect!
    assert_select "title", full_title("Log In")
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", full_title("Help")
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", full_title("Contact")
  end
  
  test "should get news" do
    get news_path
    assert_response :success
    assert_select "title", full_title("News")
  end
end

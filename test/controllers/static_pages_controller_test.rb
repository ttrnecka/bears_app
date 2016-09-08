require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
    @other_user = users(:archer)
  end
  
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", full_title("About")
  end

  test "should be redirected when getting home and not logged in" do
    get root_path
    assert_response :redirect
    assert_redirected_to login_path
    follow_redirect!
    assert_select "title", full_title("Log In")
  end
  
  test "should gett home when logged in" do
    log_in_as @user
    get root_path
    assert_template "static_pages/home"
    assert_select "title", full_title("Dashboard")
    refute_nil assigns(:graph_data)
    refute_nil assigns(:graph_data)[:instances]
    refute_nil assigns(:graph_data)[:arrays]
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", full_title("Help")
  end
  
  
  test "should get news" do
    get news_path
    assert_response :success
    assert_select "title", full_title("News")
  end
end

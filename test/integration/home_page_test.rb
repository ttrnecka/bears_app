require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
  end
    
  test "home page - dashboard with instance" do
    log_in_as @user
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "div[id=?]", "chart_capacity", count:1
  end
  
  test "home page - dashboard without instances" do
    BearsInstance.destroy_all
    log_in_as @user
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "div[id=?]", "chart_capacity", count:0
  end
end


require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tomas)
  end
    
  test "home page - dashboard" do
    log_in_as @user
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "div[id=?]", "chart_capacity_distribution", count:1
    assert_select "div[id=?]", "chart_capacity_usage", count:1
    assert_select "div[id=?]", "chart_capacity_usage_array", count:1
  end
end
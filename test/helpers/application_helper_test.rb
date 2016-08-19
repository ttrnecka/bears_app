require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "BEARS"
    assert_equal full_title("Help"), "Help | BEARS"
  end
  
  test "wrapper_id helper" do
    
  end
end
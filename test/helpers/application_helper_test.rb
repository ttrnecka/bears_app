require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include SessionsHelper
  
  test "full title helper" do
    assert_equal full_title,         "BEARS"
    assert_equal full_title("Help"), "Help | BEARS"
  end
  
  test "wrapper_id helper" do
    self.stub :logged_in?, true do
      assert_equal "page-wrapper", wrapper_id
    end
    self.stub :logged_in?, false do
      assert_equal "page-wrapper-intro", wrapper_id
    end
  end
end
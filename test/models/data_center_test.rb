require 'test_helper'

class DataCenterTest < ActiveSupport::TestCase
  def setup
    @dc = DataCenter.new(name:"Rosendal", dc_code:"NLR", bears_instance_id:bears_instances(:vpc_uk).id)
    @wynyard = data_centers(:wynyard)
  end
  
  test "should be valid" do
    assert @dc.valid?
  end
  
  test "should have uniq dc_code" do
    @dc.dc_code = @wynyard.dc_code
    assert_not @dc.valid?
  end
  
  test "should have bears instance" do
    assert @dc.bears_instance
  end
end

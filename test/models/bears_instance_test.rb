require 'test_helper'

class BearsInstanceTest < ActiveSupport::TestCase
  def setup
    @instance = BearsInstance.new(name: "VPC France", comment: "VPC France BEARS Instance")
  end
  
  test "should be valid" do
    assert @instance.valid?
  end
  
  test "name should ne uniq" do
    @instance.name = "VPC UK"
    assert_not @instance.valid?
  end
  
  test "should have data_centers" do
    assert @instance.data_centers
  end
end

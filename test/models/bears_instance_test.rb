# == Schema Information
#
# Table name: bears_instances
#
#  id         :integer          not null, primary key
#  name       :string
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bears_instances_on_name  (name) UNIQUE
#

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
  
  test "capacity_data should have label" do
    refute_nil @instance.capacity_data[:label]
  end
  
  test "capacity_data should have data and be numeric" do
    data = @instance.capacity_data
    refute_nil data
    assert_kind_of Integer, data[:data_total]
    assert_kind_of Integer, data[:data_available]
    assert_kind_of Integer, data[:data_used]
  end
end

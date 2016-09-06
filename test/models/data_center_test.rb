# == Schema Information
#
# Table name: data_centers
#
#  id                :integer          not null, primary key
#  name              :string
#  dc_code           :string(8)
#  bears_instance_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_data_centers_on_dc_code  (dc_code) UNIQUE
#

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

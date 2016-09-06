# == Schema Information
#
# Table name: resource_storage_arrays
#
#  id            :integer          not null, primary key
#  instance_id   :integer
#  instance_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_resource_storage_arrays_on_instance_id_and_instance_type  (instance_id,instance_type)
#

require 'test_helper'

module Resource::Storage
  class ArrayTest < ActiveSupport::TestCase
    def setup
      @array = Array.new()
      @wyn3par1_ab = resource_storage_arrays(:wyn3par1_ab)
    end
    
    test "should respond to instance" do
      assert @array.respond_to? :instance
    end
    
    test "api - responds to name" do
      assert @wyn3par1_ab.respond_to? :name
    end
    
    test "api - name calls instance name" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :name, -> { @called+=1; } do
          @wyn3par1_ab.name
        end
        assert @wyn3par1_ab.instance.name, @wyn3par1_ab.name
      end
    end
  end
end

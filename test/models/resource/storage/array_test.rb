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
    
    test "api - responds to serial" do
      assert @wyn3par1_ab.respond_to? :serial
    end
    
    test "api - serial calls instance serial" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :serial, -> { @called+=1; } do
          @wyn3par1_ab.serial
        end
        assert @wyn3par1_ab.instance.serial, @wyn3par1_ab.serial
      end
    end
    
    test "api - responds to model" do
      assert @wyn3par1_ab.respond_to? :model
    end
    
    test "api - model calls instance model" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :model, -> { @called+=1; } do
          @wyn3par1_ab.model
        end
        assert @wyn3par1_ab.instance.model, @wyn3par1_ab.model
      end
    end
    
    test "api - responds to firmware" do
      assert @wyn3par1_ab.respond_to? :firmware
    end
    
    test "api - firmware calls instance firmware" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :firmware, -> { @called+=1; } do
          @wyn3par1_ab.firmware
        end
        assert @wyn3par1_ab.instance.firmware, @wyn3par1_ab.firmware
      end
    end
    
    test "api - responds to space_total" do
      assert @wyn3par1_ab.respond_to? :space_total
    end
    
    test "api - space_total calls instance space_total" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :space_total, -> { @called+=1; } do
          @wyn3par1_ab.space_total
        end
        assert @wyn3par1_ab.instance.space_total, @wyn3par1_ab.space_total
      end
    end
    
    test "api - responds to space_used" do
      assert @wyn3par1_ab.respond_to? :space_used
    end
    
    test "api - space_used calls instance space_used" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :space_used, -> { @called+=1; } do
          @wyn3par1_ab.space_used
        end
        assert @wyn3par1_ab.instance.space_used, @wyn3par1_ab.space_used
      end
    end
    
    test "api - responds to space_available" do
      assert @wyn3par1_ab.respond_to? :space_available
    end
    
    test "api - space_available calls instance space_available" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :space_available, -> { @called+=1; } do
          @wyn3par1_ab.space_available
        end
        assert @wyn3par1_ab.instance.space_available, @wyn3par1_ab.space_available
      end
    end
    
    test "api - responds to family_name" do
      assert @wyn3par1_ab.respond_to? :family_name
    end
    
    test "api - family_name calls instance family_name" do
      @called = 0
      assert_difference '@called', 1 do
        @wyn3par1_ab.instance.stub :family_name, -> { @called+=1; } do
          @wyn3par1_ab.family_name
        end
        assert @wyn3par1_ab.instance.family_name, @wyn3par1_ab.family_name
      end
    end
    
    test "api - responds to data_center" do
      assert @wyn3par1_ab.respond_to? :data_center
    end
    
    test "should belong to datacenter" do
      t = Array.reflect_on_association(:data_center)
      assert_equal :belongs_to, t.macro
    end
  end
end

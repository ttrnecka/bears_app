# == Schema Information
#
# Table name: resource_storage_a3_par_arrays
#
#  id              :integer          not null, primary key
#  name            :string
#  model           :string
#  serial          :string
#  firmware        :string
#  space_total     :integer
#  space_available :integer
#  space_used      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  data_center_id  :integer
#
# Indexes
#
#  index_resource_storage_a3_par_arrays_on_data_center_id  (data_center_id)
#  index_resource_storage_a3_par_arrays_on_name            (name)
#  index_resource_storage_a3_par_arrays_on_serial          (serial) UNIQUE
#

require 'test_helper'

module Resource::Storage::A3Par
  class ArrayTest < ActiveSupport::TestCase
    def setup
      @array = Array.new(name: "WYN3PAR3", model: "V400", serial: "1234563",
                     firmware: "3.1.3 MU3 P15,P16", space_total: 200, space_available:100, space_used:100, data_center: data_centers(:wynyard))
      @wyn3par1 = resource_storage_a3_par_arrays(:wyn3par1)
    end
  
    test "should be valid" do
      assert @array.valid?
    end
    
    test "name should be present" do
      @array.name = ""
      assert_not @array.valid?
    end
    
    test "model should be present" do
      @array.model = ""
      assert_not @array.valid?
    end
    
    test "serial should be present" do
      @array.serial = ""
      assert_not @array.valid?
    end
    
    test "firmware should be present" do
      @array.firmware = ""
      assert_not @array.valid?
    end
    
    test "space_total should be present" do
      @array.space_total = nil
      assert_not @array.valid?
    end
    
    test "space_available should be present" do
      @array.space_available = nil
      assert_not @array.valid?
    end
    
    test "space_used should be present" do
      @array.space_used = nil
      assert_not @array.valid?
    end
    
    test "data_center should be present" do
      @array.data_center = nil
      assert_not @array.valid?
    end
    
    test "serial should be unique" do
      @array.serial = @wyn3par1.serial
      assert_not @array.valid?
    end
    
    test "should has_one abstract_array" do
      t = Array.reflect_on_association(:abstract_array)
      assert_equal :has_one, t.macro
    end
    
    test "should create abstract_array upon creation with the same data_center" do
      assert_nil @array.abstract_array
      @array.save
      assert @array.abstract_array.persisted?
      assert_equal @array.data_center, @array.abstract_array.data_center
    end
    
    test "should return array family_name" do
      assert_equal "3PAR", @array.family_name
    end
    
    test "should belong to data center" do
      t = Array.reflect_on_association(:data_center)
      assert_equal :belongs_to, t.macro
    end
  end
end

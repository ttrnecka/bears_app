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
#
# Indexes
#
#  index_resource_storage_a3_par_arrays_on_name    (name)
#  index_resource_storage_a3_par_arrays_on_serial  (serial) UNIQUE
#

require 'test_helper'

module Resource::Storage::A3Par
  class ArrayTest < ActiveSupport::TestCase
    def setup
      @array = Array.new(name: "WYN3PAR3", model: "V400", serial: "1234563",
                     firmware: "3.1.3 MU3 P15,P16", space_total: 200, space_available:100, space_used:100)
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
    
    test "serial should be unique" do
      @array.serial = @wyn3par1.serial
      assert_not @array.valid?
    end
    
    test "should respond to abstract_array" do
      assert @wyn3par1.respond_to? :abstract_array
      assert_equal "Resource::Storage::Array", @wyn3par1.abstract_array.class.to_s
    end
    
    test "should create abstract_array upon creation" do
      assert_nil @array.abstract_array
      @array.save
      refute_nil @array.abstract_array
    end
  end
end

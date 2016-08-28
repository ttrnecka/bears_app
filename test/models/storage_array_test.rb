require 'test_helper'

class StorageArrayTest < ActiveSupport::TestCase
  
  def setup
    @array = StorageArray.new()  
  end
  
  test "should respond to array" do
    assert @array.respond_to? :array
  end
end

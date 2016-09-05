require 'test_helper'

module Resource::Storage
  class ArrayTest < ActiveSupport::TestCase
    def setup
      @array =Array.new()  
    end
    
    test "should respond to array" do
      assert @array.respond_to? :array
    end
  end
end


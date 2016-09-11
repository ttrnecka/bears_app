require 'test_helper'

class ArraysIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:admin)
  end
  
  test "index" do
    log_in_as @admin
    get resource_storage_arrays_path
    assert_template "resource/storage/arrays/index"
    Resource::Storage::Array.all.each do |array|
      assert_select 'a[href=?]', resource_storage_array_path(array), text: array.name
    end
    assert_select 'table#arrays_table[datatable=""]', count:1
  end
end

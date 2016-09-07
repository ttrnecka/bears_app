class AddDcToResourceStorageArray < ActiveRecord::Migration[5.0]
  def change
    add_column :resource_storage_arrays, :data_center_id, :integer
    add_index :resource_storage_arrays, :data_center_id
  end
end

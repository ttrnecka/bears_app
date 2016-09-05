require_relative '20160828083727_create_storage_arrays'
class CreateResourceStorageArrays < ActiveRecord::Migration[5.0]
  def change
    revert CreateStorageArrays
    
    create_table :resource_storage_arrays do |t|
      t.integer :array_id
      t.string :array_type

      t.timestamps
    end
    
    add_index :resource_storage_arrays, [:array_id, :array_type]
  end
end

class CreateResourceStorageEvaArrays < ActiveRecord::Migration[5.0]
  def change
    create_table :resource_storage_eva_arrays do |t|
      t.string :name
      t.string :model
      t.string :serial
      t.string :firmware
      t.integer :space_total
      t.integer :space_available
      t.integer :space_used
      t.integer :data_center_id
      t.timestamps
    end
    add_index :resource_storage_eva_arrays, :serial, unique: true
    add_index :resource_storage_eva_arrays, :name
    add_index :resource_storage_eva_arrays, :data_center_id
  end
end

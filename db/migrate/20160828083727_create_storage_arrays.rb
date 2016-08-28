class CreateStorageArrays < ActiveRecord::Migration[5.0]
  def change
    create_table :storage_arrays do |t|
      t.integer :array_id
      t.string :array_type

      t.timestamps
    end
    add_index :storage_arrays, [:array_id, :array_type]
  end
end

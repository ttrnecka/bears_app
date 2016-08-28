class CreateDataCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :data_centers do |t|
      t.string :name
      t.string :dc_code, limit: 8
      t.integer :bears_instance_id

      t.timestamps
    end
    add_index :data_centers, :dc_code, unique: true
  end
end

class CreateBearsInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :bears_instances do |t|
      t.string :name
      t.string :comment

      t.timestamps
    end
    add_index :bears_instances, :name, unique: true
  end
end

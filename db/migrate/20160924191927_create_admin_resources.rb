class CreateAdminResources < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_resources do |t|
      t.string :address
      t.string :protocol
      t.integer :credential_id
      t.integer :bears_instance_id

      t.timestamps
    end
  end
end

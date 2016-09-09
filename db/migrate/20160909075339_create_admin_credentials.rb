class CreateAdminCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_credentials do |t|
      t.string :account
      t.string :encrypted_password
      t.string :encrypted_password_iv
      t.string :description

      t.timestamps
    end
    add_index :admin_credentials, :description, unique: true
  end
end

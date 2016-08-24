class AddRolesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :roles, :string, limit: 2, default:"U"
  end
end

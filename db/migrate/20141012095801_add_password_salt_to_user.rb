class AddPasswordSaltToUser < ActiveRecord::Migration
  def change
    add_column :users, :pwd_salt, :string
  end
end

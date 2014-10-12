class AddDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :is_valid, :boolean, default: true
    change_column :users, :email_valid, :boolean, default: false
    change_column :users, :sex, :string, default: 'male'

    change_column :events, :is_valid, :boolean, default: false
  end
end

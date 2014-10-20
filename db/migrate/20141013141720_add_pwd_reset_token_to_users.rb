class AddPwdResetTokenToUsers < ActiveRecord::Migration
  def change
    add_column  :users, :reset_password_token, :string
    add_index   :users, :reset_password_token

    add_column  :users, :email_confirmation_token, :string
    add_index   :users, :email_confirmation_token
  end
end

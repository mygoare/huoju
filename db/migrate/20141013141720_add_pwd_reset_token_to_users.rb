class AddPwdResetTokenToUsers < ActiveRecord::Migration
  def change
    add_column  :users, :pwd_reset_token, :string
    add_index   :users, :pwd_reset_token
  end
end

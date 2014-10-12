class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string  :email
      t.boolean :email_valid
    	t.string	:user_name
    	t.string	:pwd_hash
      t.string  :pwd_salt
    	t.string 	:avatar
    	t.boolean :is_valid
    	t.text		:profile
    	t.string	:sex

      t.timestamps
    end
  end
end

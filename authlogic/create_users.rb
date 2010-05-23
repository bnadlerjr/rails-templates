# == Description
# Creates a basic user table with support for authenticatin and authorization.
class CreateUsers < ActiveRecord::Migration
 def self.up
   create_table :users, :force => true do |t|
     t.string :email,               :null => false
     t.string :first_name,          :null => false
     t.string :last_name,           :null => false
     t.string :crypted_password,    :null => false
     t.string :password_salt,       :null => false
     t.string :persistence_token,   :null => false
     t.string :single_access_token, :null => false
     t.string :perishable_token,    :null => false
     t.string :roles
     t.string :current_login_ip
     t.string :last_login_ip

     t.integer :login_count,        :null => false, :default => 0
     t.integer :failed_login_count, :null => false, :default => 0

     t.datetime :last_request_at
     t.datetime :current_login_at
     t.datetime :last_login_at
   end

   add_index :users, :email
   add_index :users, :perishable_token
 end

 def self.down
   remove_index :users, :perishable_token
   remove_index :users, :email
   drop_table :users
 end
end

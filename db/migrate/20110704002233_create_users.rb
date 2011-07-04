class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.boolean :admin, :default => false
      
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
    add_index :users, :username, :unique => true
  end
end

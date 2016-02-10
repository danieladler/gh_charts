class CreateUser < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :uid
      t.string :username
      t.string :email
      t.string :avatar_url
      t.string :token
  	end
  end

  def down
  	drop_table :users
  end
end

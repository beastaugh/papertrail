class CreateAuthenticationMigration < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :password_digest
    end
    
    add_index :users, :email
  end

  def down
    drop_table :users
  end
end

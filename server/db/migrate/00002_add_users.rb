class AddUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.text :uuid
      t.text :username
      t.text :email
      t.text :password

      t.timestamps
    end

    add_index :users, :uuid,     unique: true
    add_index :users, :username, unique: true
    add_index :users, :email,    unique: true
  end

  def down
    drop_table :users
  end
end

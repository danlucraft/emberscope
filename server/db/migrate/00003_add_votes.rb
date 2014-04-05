
class AddVotes < ActiveRecord::Migration
  def up
    create_table :votes do |t|
      t.integer :post_id
      t.integer :user_id

      t.timestamps
    end

    add_index :votes, [:post_id, :user_id], unique: true
    add_index :votes, :user_id
  end

  def down
    drop_table :votes
  end
end

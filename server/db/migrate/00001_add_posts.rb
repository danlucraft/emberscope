class AddPosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.string  :uuid
      t.string  :title
      t.string  :url
      t.text    :text
      t.timestamps
    end
    add_index :posts, :uuid, unique: true
  end

  def down
    drop_table :posts
  end
end

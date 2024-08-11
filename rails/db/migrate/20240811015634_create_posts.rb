class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :body, null: true
      t.string :image_url, null: true
      t.string :is_published, default: '0'
      t.string :uid, unique: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :posts, :uid, unique: true
  end
end
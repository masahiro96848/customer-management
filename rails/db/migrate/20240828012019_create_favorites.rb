class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

     # ユーザーと投稿の組み合わせがユニークであることを保証
    add_index :favorites, [:user_id, :post_id], unique: true
  end
end

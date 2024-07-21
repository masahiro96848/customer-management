class CreateSessionCookies < ActiveRecord::Migration[7.0]
  def change
    create_table :session_cookies do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :session_cookies, :token, unique: true
    add_index :session_cookies, [:user_id, :created_at]
  end
end

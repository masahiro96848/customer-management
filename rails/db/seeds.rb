# userを生成
10.times do |i|
  name = "サンプルテスト#{i + 1}"
  email = "sample#{"%02d" % (i + 1)}@test.com"
  bio = Faker::Lorem.paragraph(sentence_count: 5)
  # ダミー画像をランダムに選択
  image_filename = ["dummy_man.jpg", "dummy_woman.jpg"].sample
  image_url = File.open("./app/assets/images/#{image_filename}")
  if User.exists?(email:)
    Rails.logger.debug "Email #{email} は既に存在します。"
  else
    user = User.create!(
      name:,
      email:,
      password: "password",
      bio:,
      image_url:,
    )
    if user.errors.any?
      Rails.logger.debug user.errors.full_messages
    end
  end
end

# 作成したユーザーのIDを取得
user_ids = User.pluck(:id)

# postを生成
post_ids = []
30.times do
  title = ["TypeScriptのタイトル", "Ruby on Railsのタイトル", "Node.jsのタイトル"].sample
  body = Faker::Lorem.paragraph(sentence_count: 5)
  image_url = File.open("./app/assets/images/dummy_background.jpg")
  is_published = [1, 2].sample
  uid = SecureRandom.uuid

  post = Post.create!(
    title:,
    body:,
    image_url:,
    is_published:,
    uid:,
    user_id: user_ids.sample,
  )
  if post.errors.any?
    Rails.logger.debug post.errors.full_messages
  else
    post_ids << post.id
  end
end

# Favoriteデータを生成
20.times do
  user_id = user_ids.sample
  post_id = post_ids.sample

  # Favoriteがすでに存在するかチェック
  if Favorite.exists?(user_id:, post_id:)
    Rails.logger.debug "Favorite already exists for User ID: #{user_id}, Post ID: #{post_id}"
  else
    favorite = Favorite.create!(
      user_id:,
      post_id:,
    )

    if favorite.errors.any?
      Rails.logger.debug favorite.errors.full_messages
    else
      Rails.logger.debug "Favorite created for User ID: #{user_id}, Post ID: #{post_id}"
    end
  end
end

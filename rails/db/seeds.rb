# userを生成
10.times do |i|
  email = "sample#{"%02d" % (i + 1)}@test.com"
  if User.exists?(email:)
    Rails.logger.debug "Email #{email} は既に存在します。"
  else
    user = User.create!(
      name: "サンプルテスト#{i + 1}",
      email:,
      password: "password",
    )
    if user.errors.any?
      Rails.logger.debug user.errors.full_messages
    end
  end
end

# 作成したユーザーのIDを取得
user_ids = User.pluck(:id)

# postを生成
30.times do
  title = ["TypeScriptのタイトル", "Ruby on Railsのタイトル", "Node.jsのタイトル"].sample
  body = Faker::Lorem.paragraph(sentence_count: 5)
  image_url = Faker::LoremFlickr.image(search_terms: ["landscape"])
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
  end
end

module Mutations
  class PostEdit < Mutations::BaseMutation
    argument :title, String, required: true
    argument :body, String, required: false
    argument :image_url, String, required: false
    argument :uid, String, required: true
    argument :is_published, Int, required: true

    field :post, Types::PostType, null: false
    field :errors, [String], null: false

    def resolve(title:, uid:, is_published:, body: nil, image_url: nil)
      user = context[:current_user]
      return { post: nil, errors: ["User not authenticated"] } unless user

      # uidに基づいて既存のポストを取得
      post = user.posts.find_by(uid:)

      if post
        # 既存のポストがある場合、更新
        if post.update(title:, body:, image_url:, is_published:)
          { post:, errors: [] }
        else
          { post: nil, errors: post.errors.full_messages }
        end
      else
        # 既存のポストがない場合、新規作成
        post = user.posts.new(
          title:,
          body:,
          image_url:,
          is_published:,
          uid:,
        )

        if post.save
          { post:, errors: [] }
        else
          { post: nil, errors: post.errors.full_messages }
        end
      end
    end
  end
end

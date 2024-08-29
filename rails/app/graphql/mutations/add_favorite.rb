module Mutations
  class AddFavorite < Mutations::BaseMutation
    argument :post_id, ID, required: true

    field :favorite, Types::FavoriteType, null: true
    field :post, Types::PostType, null: true
    field :errors, [String], null: false

    def resolve(post_id:)
      user = context[:current_user]
      return { post: nil, errors: ["User not signed in"] } if user.nil?

      post = Post.find_by(id: post_id)
      return { post: nil, errors: ["Post not found"] } if post.nil?

      favorite = Favorite.new(user:, post:)

      if favorite.save
        { favorite:, post:, errors: [] }
      else
        { favorite: nil, post: nil, errors: favorite.errors.full_messages }
      end
    end
  end
end

module Mutations
  class RemoveFavorite < Mutations::BaseMutation
    argument :post_id, ID, required: true

    field :post, Types::PostType, null: true
    field :errors, [String], null: false
    field :success, Boolean, null: false

    def resolve(post_id:)
      user = context[:current_user]
      return { success: false, errors: ["User not logged in"] } unless user

      favorite = Favorite.find_by(user:, post_id:)
      return { success: false, errors: ["Favorite not found"] } unless favorite

      post = favorite.post

      if favorite.destroy
        { post:, success: true, errors: [] }
      else
        { post: nil, success: false, errors: favorite.errors.full_messages }
      end
    end
  end
end

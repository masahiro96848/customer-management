# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map {|id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
                               description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end
    def user(id:)
      User.find(id)
    end

    field :users, [Types::UserType], null: false
    def users
      User.all
    end

    field :viewer, Types::UserType, null: true
    def viewer
      context[:current_user]
    end

    field :posts, [Types::PostType], null: false do
      argument :limit, Int, required: false, default_value: 12
      argument :offset, Int, required: false, default_value: 0
    end

    def posts(limit:, offset:)
      Post.limit(limit).offset(offset)
    end

    field :total_posts, Int, null: false
    def total_posts
      Post.count
    end

    field :post_detail, Types::PostType, null: false do
      argument :uid, String, required: true
      argument :name, String, required: true
    end
    def post_detail(uid:, name:)
      user = User.find_by(name:)
      return nil unless user

      Post.find_by(uid:, user_id: user.id)
    end

    field :post_edit, Types::PostType, null: true do
      argument :uid, String, required: false
    end
    def post_edit(uid:)
      return nil if uid.blank?
      Post.find_by(uid:)
    end

    field :edit_post, Types::PostType, null: true do
      argument :uid, String, required: true
    end
    def edit_post(uid:)
      Post.find_by(uid:)
    end

    field :myposts, [Types::PostType], null: false do
      argument :limit, Int, required: false, default_value: 12
      argument :offset, Int, required: false, default_value: 0
    end
    def myposts(limit:, offset:)
      user = context[:current_user]
      return [] unless user

      Post.where(user_id: user.id)
    end
  end
end

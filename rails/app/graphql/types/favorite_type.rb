# frozen_string_literal: true

module Types
  class FavoriteType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: false
    field :post_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # 関連するUserとPostを取得できるようにフィールドを定義
    field :user, Types::UserType, null: false
    field :post, Types::PostType, null: false
  end
end

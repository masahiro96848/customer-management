# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :body, String
    field :image_url, String
    field :is_published, Int
    field :uid, String, null: false
    field :user, Types::UserType, null: false
    field :favorites_count, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def published
      object.is_published == 0
    end

    def image_url
      # CarrierWaveで生成されたURLを返す
      object.image_url.url if object.image_url.present?
    end

    def favorites_count
      object.favorites.count
    end
  end
end

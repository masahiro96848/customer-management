# frozen_string_literal: true

class ObjectTypes::User < Types::BaseObject
  field :id, ID, null: false
  field :name, String
  field :email, String
  field :password, String
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end

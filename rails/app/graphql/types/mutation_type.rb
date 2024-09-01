# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :test_field, String, null: false,
                               description: "An example field added by the generator"
    def test_field
      "Hello World"
    end

    field :signin, mutation: Mutations::Signin
    field :signup, mutation: Mutations::Signup
    field :signout, mutation: Mutations::Signout
    field :post_edit, mutation: Mutations::PostEdit
    field :add_favorite, mutation: Mutations::AddFavorite
    field :remove_favorite, mutation: Mutations::RemoveFavorite
    field :post_sort, mutation: Mutations::PostSort
    field :profile_edit, mutation: Mutations::ProfileEdit
  end
end

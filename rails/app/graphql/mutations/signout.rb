module Mutations
  class Signout < Mutations::BaseMutation
    null false
    type Boolean

    def resolve
      user = context[:current_user]

      raise GraphQL::ExecutionError, "User not signed in" unless user

      user.delete_session_cookie!(context)
      true
    end
  end
end

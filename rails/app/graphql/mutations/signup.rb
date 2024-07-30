module Mutations
  class Signup < Mutations::BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(params)
      user = User.create(params)

      if user.persisted?
        user.create_token_cookie(context)
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end

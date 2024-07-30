module Mutations
  class Signin < Mutations::BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      user, errors = User.authenticate_with_credentials(email, password)
      return { user: nil, errors: } if user.nil?

      user.reset_token!
      user.create_token_cookie(context)

      {
        user:,
        errors: [],
      }
    rescue => e
      {
        user: nil,
        errors: [e.message],
      }
    end
  end
end

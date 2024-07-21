module Mutations
  class Signin < Mutations::BaseMutation
    # include Concerns::SessionCookie

    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      user = User.find_by(email:)
      if user && user.authenticate(password)
        # create_session_cookie(user)
        {
          user:,
          errors: [],
        }
      else
        {
          user: nil,
          errors: ["Invalid email or password"],
        }
      end
    rescue => e
      {
        user: nil,
        errors: [e.message],
      }
    end
  end
end

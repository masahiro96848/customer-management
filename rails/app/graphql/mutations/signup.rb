module Mutations
  class Signup < Mutations::BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(email:, password:, password_confirmation:)
      user = User.new(email:, password:, password_confirmation:)
      if user.save
        {
          user:,
          errors: [],
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages,
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

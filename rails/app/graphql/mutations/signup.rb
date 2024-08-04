module Mutations
  class Signup < Mutations::BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(params)
      if User.exists?(email: params[:email])
        return raise Errors.create(:email_has_already_been_taken)
      end

      user = User.new(params)

      raise Errors.create(:email_has_already_been_taken) unless user.save

      user.create_token_cookie(context)
      { user:, errors: [] }
    end
  end
end

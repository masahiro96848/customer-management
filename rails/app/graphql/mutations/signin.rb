module Mutations
  class Signin < Mutations::BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(email:, password:)
      user = User.signin_credentials(email, password)

      if user.nil?
        raise Errors.create(:login_email_and_password_mismatch)
      end

      user.reset_token!
      user.create_token_cookie(context)

      {
        user:,
        errors: [],
      }
    rescue ActiveRecord::RecordNotFound
      context[:response].status = 400
      {
        user: nil,
        errors: ["メールアドレスまたはパスワードが正しくありません。"],
      }
    end
  end
end

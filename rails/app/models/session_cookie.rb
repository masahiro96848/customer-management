class SessionCookie < ApplicationRecord
  TOKEN_COOKIE_NAME = "dev_session_token".freeze

  belongs_to :user

  before_validation(on: :create) do
    self.token = SecureRandom.alphanumeric(32)
  end

  def token_cookie_attributes
    {
      value: token,
      httponly: true,
    }
  end
end

class User < ApplicationRecord
  has_secure_password

  before_create :generate_token

  validates :email, presence: true, uniqueness: true

  TOKEN_COOKIE_NAME = "dev_session_token".freeze

  def self.signin_credentials(email, password)
    user = find_by(email:)
    if user&.authenticate(password)
      [user, []]
    else
      [nil, ["Invalid email or password"]]
    end
  end

  def reset_token!
    self.token = SecureRandom.alphanumeric(32)
    self.save!
  end

  def generate_token
    self.token = SecureRandom.alphanumeric(32)
  end

  def create_token_cookie(context)
    context[:response].set_cookie(
      TOKEN_COOKIE_NAME,
      {
        value: self.token,
        expires: 1.year.from_now,
        http_only: true,
        secure: Rails.env.production?,
      },
    )
  end

  def delete_session_cookie!(context)
    context[:response].delete_cookie(TOKEN_COOKIE_NAME)
    update!(token: nil)
  end
end

class User < ApplicationRecord
  has_secure_password

  before_create :generate_token

  validates :email, presence: true, uniqueness: true

  TOKEN_COOKIE_NAME = "dev_session_token".freeze

  def self.authenticate_with_credentials(email, password)
    user = find_by(email:)
    if user && user.authenticate(password)
      [user, []]
    else
      [nil, ["Invalid email or password"]]
    end
  end

  def reset_token!
    self.token = SecureRandom.alphanumeric(32) unless self.token
    self.update!(token:)
  end

  def generate_token(context)
    token = SecureRandom.alphanumeric(32)
    self.update!(token:)
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
end

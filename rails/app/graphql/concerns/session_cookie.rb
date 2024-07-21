module Concerns
  module SessionCookie
    extend ActiveSupport::Concern

    def create_session_cookie(user)
      new_session_cookie = ::SessionCookie.create!(user:)
      context[:cookies][::SessionCookie::TOKEN_COOKIE_NAME] = new_session_cookie.token_cookie_attributes
      new_session_cookie
    end
  end
end

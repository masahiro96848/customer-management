module Errors
  include Errors::Definition
  include Errors::Creation

  define :login_email_and_password_mismatch, code: 400
end

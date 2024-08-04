module Errors
  include Errors::Definition
  include Errors::Creation

  define :login_email_and_password_mismatch, code: 400
  define :email_has_already_been_taken, code: 400
end

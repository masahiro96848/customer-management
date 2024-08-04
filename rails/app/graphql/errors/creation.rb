module Errors::Creation
  extend ActiveSupport::Concern

  module ClassMethods
    def create(key, message: nil)
      raise ArgumentError, "An Error named #{key} is not defined." unless @errors[key]

      message ||= I18n.t("errors.#{key}")
      GraphQL::ExecutionError.new(message, extensions: {
        code: @errors[key][:code],
        detailed_code: key.to_s.upcase,
      })
    end
  end
end

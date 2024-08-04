module Errors::Definition
  extend ActiveSupport::Concern

  module ClassMethods
    def define(key, code:)
      @errors ||= {}
      @errors[key] = {
        key:,
        code:,
      }
    end

    def errors
      @errors
    end
  end
end

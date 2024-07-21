# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      response:,
      # cookies: cookies
      # current_user: current_user,
      # current_session_cookie: current_session_cookie
    }
    result = MyappSchema.execute(query, variables:, context:, operation_name:)
    render json: result
  rescue => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

    # Handle variables in form data, JSON body, or a blank value
    def prepare_variables(variables_param)
      case variables_param
      when String
        if variables_param.present?
          JSON.parse(variables_param) || {}
        else
          {}
        end
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{variables_param}"
      end
    end

    def handle_error_in_development(e)
      logger.error e.message
      logger.error e.backtrace.join("\n")

      render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: :internal_server_error
    end

    def session_token
      cookies[SessionCookie::TOKEN_COOKIE_NAME]
    end

    def current_session_cookie
      return nil unless session_token

      @session_cookie ||= SessionCookie.find_by(token: session_token)
      if @session_cookie && !@session_cookie.expired?
        @session_cookie
      else
        nil
      end
    end

    def current_user
      current_session_cookie&.user
    end
end

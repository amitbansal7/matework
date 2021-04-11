# frozen_string_literal: true

module V1
  module Helpers
    module Authentication
      extend Grape::API::Helpers

      def current_user
        return unless auth_token

        @current_user ||= JwtService.get_user(auth_token)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user.present?
      end

      def auth_token
        headers['Authorization']
      end
    end
  end
end

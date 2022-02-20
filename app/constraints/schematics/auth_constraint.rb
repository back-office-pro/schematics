# frozen_string_literal: true

module Schematics
  class AuthConstraint
    class << self
      def matches?(request)
        auth_token = request.cookies['auth_token']
        current_user(auth_token).present?
      end

      def current_user(auth_token)
        ::User.find_by(auth_token:) if auth_token
      end
    end
  end
end

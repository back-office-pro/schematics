# frozen_string_literal: true

module Core
  module Sessions
    class SignIn
      include Schematics::Interactable
      delegate :user, :cookies, :resource_params, to: :context, private: true

      def call
        fail! unless user

        context.current_session_id = session.id
        context.jwt = JWT::AuthToken.encode(session.auth_token)
        cookies.permanent.encrypted[:auth_token] = cookie if remember_me?
      end

      private

      def remember_me? = ::ActiveModel::Type::Boolean
        .new
        .cast(resource_params[:remember_me])

      def cookie = { value: session.auth_token, httponly: true }

      memoize def session = context
        .session
        .login!(user)
    end
  end
end

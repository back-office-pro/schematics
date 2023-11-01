# frozen_string_literal: true

module Core
  module Sessions
    # :reek:MissingSafeMethod
    class Create
      include Schematics::Interactable

      delegate :can?, to: :ability, private: true
      delegate :cookies, :ability, :resource_params, to: :context, private: true

      before { @user = ::User.authenticate_by(email:, password:) }

      def call
        fail! unless authenticated? || omniauthenticated? || impersonated?

        context.current_session_id = session.id
        context.jwt = JWT::AuthToken.encode(session.auth_token)
        cookies.permanent.encrypted[:auth_token] = cookie if remember_me?
      end

      private

      def authenticated?
        @user.present?
      end

      def impersonated?
        can?(:impersonate, user)
      end

      def omniauthenticated?
        resource_params.is_a?(OmniAuth::AuthHash::InfoHash) && user.id.present?
      end

      def email = resource_params[:email]

      def password = resource_params[:password]

      def remember_me? = ::ActiveModel::Type::Boolean
        .new
        .cast(resource_params[:remember_me])

      def cookie = { value: session.auth_token, httponly: true }

      memoize def session = context
        .session
        .login!(user)

      memoize def user
        @user || ::User.find_by(email:) || Schematics::Guest::User.new
      end
    end
  end
end

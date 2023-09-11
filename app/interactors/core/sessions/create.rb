# frozen_string_literal: true

module Core
  module Sessions
    # :reek:MissingSafeMethod
    class Create
      include Schematics::Interactable

      delegate :cannot?, to: :current_ability, private: true
      delegate :cookies,
               :current_session,
               :current_ability,
               :resource_params,
               :omniauth,
               to: :context,
               private: true

      def call
        fail!(message: '.unconfirmed') if unconfirmed?
        fail! unless authenticate(password) # TODO: use authenticate_by when upgrading to Rails 7.1

        session = current_session.login!(user)
        context.current_session_id = session.id
        context.jwt = JWT::AuthToken.encode(session.auth_token)
        cookies.permanent.encrypted[:auth_token] = session.auth_token if remember_me?
      end

      private

      def fail!(message: '.failure')
        super if cannot?(:impersonate, user)
      end

      def authenticate(password)
        return true if omniauth
        return false unless user

        user.authenticate(password)
      end

      def email = resource_params[:email] || omniauth.info.email

      def password
        context.password || resource_params[:password]
      end

      def remember_me? = ::ActiveModel::Type::Boolean
        .new
        .cast(resource_params[:remember_me])

      def unconfirmed?
        !omniauth && user && !user.confirmed?
      end

      def user
        context.resource || ::User.find_by(email:)
      end
    end
  end
end

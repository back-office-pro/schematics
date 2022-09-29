# frozen_string_literal: true

module Application
  module Sessions
    # :reek:MissingSafeMethod
    class Create
      include Schematics::Interactable

      delegate :authenticate, to: :user, allow_nil: true, private: true
      delegate :cannot?, to: :current_ability, private: true
      delegate :cookies,
               :current_session,
               :current_ability,
               :resource_params,
               to: :context,
               private: true

      def call
        fail!(message: '.unconfirmed') if user && !user.confirmed?
        fail! unless authenticate(password) # TODO: use authenticate_by when upgrading to Rails 7.1

        session = current_session.login!(user)
        context.current_session_id = session.id
        context.jwt = ::JsonWebToken.encode(auth_token: session.auth_token)
        cookies.permanent.encrypted[:auth_token] = session.auth_token if remember_me?
      end

      private

      def fail!(message: '.failure')
        return super if cannot?(:impersonate, user)
      end

      def password
        context.password || resource_params[:password]
      end

      def remember_me? = ::ActiveModel::Type::Boolean
        .new
        .cast(resource_params[:remember_me])

      def user
        context.resource || ::User.find_by(email: resource_params[:email])
      end
    end
  end
end

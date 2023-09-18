# frozen_string_literal: true

module Core
  module Sessions
    # :reek:MissingSafeMethod
    class Create
      include Schematics::Interactable

      delegate :authenticate, :confirmed?, to: :user, private: true
      delegate :can?, to: :current_ability, private: true
      delegate :cookies,
               :current_session,
               :current_ability,
               :resource_params,
               to: :context,
               private: true

      def call
        fail!(message: '.unconfirmed') unless confirmed?
        fail! unless authenticate(password) # TODO: use authenticate_by when upgrading to Rails 7.1

        session = current_session.login!(user)
        context.current_session_id = session.id
        context.jwt = JWT::AuthToken.encode(session.auth_token)
        cookies.permanent.encrypted[:auth_token] = session.auth_token if remember_me?
      end

      private

      def fail!(message: '.failure')
        super unless omniauthenticated? || can?(:impersonate, user)
      end

      def omniauthenticated?
        resource_params.is_a?(OmniAuth::AuthHash::InfoHash) && user.id.present?
      end

      def password
        context.password || resource_params[:password]
      end

      def remember_me? = ::ActiveModel::Type::Boolean
        .new
        .cast(resource_params[:remember_me])

      def user
        context.resource ||
          ::User.find_by(email: resource_params[:email]) ||
          Schematics::Guest::User.new
      end
    end
  end
end

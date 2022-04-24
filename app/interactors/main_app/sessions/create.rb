# frozen_string_literal: true

module MainApp
  module Sessions
    class Create
      include Schematics::Interactable
      delegate :authenticate, to: :@user, allow_nil: true

      before do
        @session = context.current_session
        @params = context.resource_params
        @password = context.password || @params[:password]
        @user = context.resource || ::User.find_by(email: @params[:email])
        @cookies = context.cookies
      end

      def call
        fail! unless authenticate(@password) # TODO: use authenticate_by when upgrading to Rails 7

        session = @session.login!(@user)
        context.current_session_id = session.id
        context.jwt = ::JsonWebToken.encode(auth_token: session.auth_token)
        @cookies.permanent.encrypted[:auth_token] = session.auth_token if remember_me?
      rescue BCrypt::Errors::InvalidHash
        fail!(message: '.invalid_hash')
      end

      private

      def remember_me?
        @params&.fetch(:remember_me, false)
      end
    end
  end
end

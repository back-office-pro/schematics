# frozen_string_literal: true

module Application
  module Sessions
    # :reek:MissingSafeMethod
    class Create
      include Schematics::Interactable
      delegate :authenticate, to: :@user, allow_nil: true
      delegate :cannot?, to: :@ability

      before do
        @session = context.current_session
        @ability = context.current_ability
        @params = context.resource_params
        @password = context.password || @params[:password]
        @user = context.resource || ::User.find_by(email: @params[:email])
        @cookies = context.cookies
      end

      def call
        fail!(message: '.unconfirmed') if @user && !@user.confirmed?
        fail! unless authenticate(@password) # TODO: use authenticate_by when upgrading to Rails 7.1

        session = @session.login!(@user)
        context.current_session_id = session.id
        context.jwt = ::JsonWebToken.encode(auth_token: session.auth_token)
        @cookies.permanent.encrypted[:auth_token] = session.auth_token if remember_me?
      end

      private

      def fail!(message: '.failure')
        return super if cannot?(:impersonate, @user)
      end

      def remember_me?
        @params&.fetch(:remember_me, false)
      end
    end
  end
end

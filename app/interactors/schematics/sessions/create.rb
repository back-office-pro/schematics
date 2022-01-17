# frozen_string_literal: true

module Schematics
  module Sessions
    class Create
      include Interactable
      delegate :authenticate, :auth_token, to: :@user, allow_nil: true

      before do
        @params = context.user_params
        @password = context.password || @params[:password]
        @user = context.resource || User.find_by(email: @params[:email])
        @remember_me = @params&.fetch(:remember_me, false)
        @cookies = context.cookies&.tap { _1.permanent if @remember_me }
      end

      def call
        fail! unless authenticate(@password)

        context.token = auth_token
        context.jwt = JsonWebToken.encode(auth_token:)
        @cookies[:auth_token] = auth_token if @cookies
      rescue BCrypt::Errors::InvalidHash
        fail!(message: '.invalid_hash')
      end
    end
  end
end

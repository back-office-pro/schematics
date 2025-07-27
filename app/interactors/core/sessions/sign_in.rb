# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Sessions
    class SignIn
      include Schematics::Interactable

      delegate :user, :otp_token, :cookies, :resource_params, to: :context, private: true

      def call
        fail! unless user

        if otp_token
          context.message = '.challenge'
        else
          context.session = session
          cookies.permanent.encrypted[:access_token] = cookie if remember_me?
        end
      end

      private

      def remember_me? = ::ActiveModel::Type::Boolean
        .new
        .cast(resource_params[:remember_me])

      def cookie = { value: session.id, httponly: true }

      memoize def session = context
        .session
        .login!(user)
    end
  end
end

# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Update
      include Interactable
      delegate :user, :user_params, to: :context, private: true

      def call
        fail!(message: '.expired') if user.password_reset_token_expired?
        fail! unless user.update(params)
      end

      private

      def params = user_params.merge(password_reset_token: nil)
    end
  end
end

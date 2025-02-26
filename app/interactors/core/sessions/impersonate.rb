# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Sessions
    class Impersonate
      include Schematics::Interactable
      delegate :cannot?, to: :ability, private: true
      delegate :ability, :resource_params, to: :context, private: true

      def call
        return if cannot?(:impersonate, user)

        context.user = user
        context.otp_token = nil
      end

      private

      memoize def user = Demo::User.find_by(email:)

      def email = resource_params[:email]
    end
  end
end

# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Create
      include Interactable
      delegate :email, :url_options, to: :context, private: true

      def call
        UserMailer.password_reset(user, url_options).deliver_later if user
      end

      private

      def user = ::User.find_by(email:)
    end
  end
end

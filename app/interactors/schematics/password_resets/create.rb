# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Create
      include Interactable

      delegate :email, to: :context, private: true

      def call
        UserMailer.password_reset(user).deliver_later if user
      end

      private

      def user = ::User.find_by(email:)
    end
  end
end

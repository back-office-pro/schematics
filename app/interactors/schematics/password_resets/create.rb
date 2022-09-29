# frozen_string_literal: true

module Schematics
  module PasswordResets
    class Create
      include Interactable
      delegate :email, to: :context, private: true

      def call
        fail! unless user

        user.regenerate_password_reset_token
        user.update!(reset_password_sent_at: ::Time.current)
        UserMailer.password_reset(user).deliver_later
      end

      private

      def user = ::User.find_by(email:)
    end
  end
end

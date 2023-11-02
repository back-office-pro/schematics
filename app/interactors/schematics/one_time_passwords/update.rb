# frozen_string_literal: true

module Schematics
  module OneTimePasswords
    class Update
      include Interactable

      delegate :resource, to: :context, private: true
      delegate :user, :verify, :secret, to: :resource, private: true

      def call
        fail! unless verify

        user.update!(otp_secret: secret)
      end
    end
  end
end

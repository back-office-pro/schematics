# frozen_string_literal: true

module Schematics
  module OneTimePasswords
    class Destroy
      include Interactable
      delegate :user, to: :context, private: true

      def call
        fail! unless user.disable_otp
      end
    end
  end
end

# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module OneTimePasswords
    class Destroy
      include Interactable

      delegate :user, to: :context, private: true

      def call
        user.otp_regenerate_secret
        user.otp_regenerate_backup_codes
        user.otp_last_at = nil
        fail! unless user.save
      end
    end
  end
end

# frozen_string_literal: true

module Schematics
  module OneTimePasswordBackupCodes
    class Component < ApplicationComponent
      delegate :otp_enabled?, :otp_backup_codes, to: :current_user, private: true

      alias render? otp_enabled?
    end
  end
end

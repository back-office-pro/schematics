# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Core
  module User
    extend ActiveSupport::Concern

    NEW_ACCOUNT_TOKEN_DURATION = 24.hours.freeze
    ONE_TIME_PASSWORD_DURATION = 10.minutes.freeze

    prepended do
      attribute :time_zone, default: -> { ::Configuration.time_zone_with_fallback }
      attribute :locale, default: -> { ::Configuration.locale }

      store_accessor :preferences,
                     :sidebar_toggled,
                     :theme,
                     prefix: true

      validate :secure_password_challenge

      delegate :admin?, to: :role

      after_create_commit :deliver_new_account_mailer

      generates_token_for :new_account, expires_in: NEW_ACCOUNT_TOKEN_DURATION do
        password_salt&.last(10)
      end

      generates_token_for :one_time_password, expires_in: ONE_TIME_PASSWORD_DURATION do
        otp_last_at
      end
    end

    def online?
      @online ||= sessions.active.exists?
    end

    def to_s
      full_name.presence || email
    end

    def log_search!(model, filters)
      searches.create!(model:, filters:) if filters.any?
    end

    def find_or_create_draft!(record_type, record_id)
      user_drafts
        .with_string_translations
        .find_or_create_by!(record_type:, record_id:)
    end

    private

    def secure_password_challenge
      return unless password_challenge
      return unless password_digest_was
      return if BCrypt::Password.new(password_digest_was).is_password?(password_challenge)

      errors.add(:password_challenge)
    end

    def deliver_new_account_mailer = Schematics::UserMailer
      .new_account(self, ::Tenant.default_url_options)
      .deliver_later
  end
end

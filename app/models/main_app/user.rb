# frozen_string_literal: true

module MainApp
  module User
    extend ActiveSupport::Concern

    ONLINE_DELAY = 15.minutes.freeze
    PASSWORD_RESET_TOKEN_DURATION = 2.hours.freeze

    prepended do
      after_create :regenerate_password_reset_token
      after_create { Schematics::UserMailer.new_account(self).deliver_later }
      scope :online, -> { where(last_seen_at: ONLINE_DELAY.ago..).order(last_seen_at: :desc) }
    end

    def online?
      return false unless last_seen_at

      ONLINE_DELAY.ago.before?(last_seen_at)
    end

    def password_reset_token_expired?
      return false unless password_digest

      PASSWORD_RESET_TOKEN_DURATION.ago.after?(reset_password_sent_at)
    end
  end
end

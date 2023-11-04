# frozen_string_literal: true

class User < Schematics::ApplicationRecord
  PASSWORD_RESET_TOKEN_DURATION = 24.hours.freeze

  attribute :time_zone, default: -> { ::Configuration.time_zone }
  attribute :locale, default: -> { ::Configuration.locale }

  validate :secure_password_challenge

  delegate :admin?, to: :role

  after_create_commit { Schematics::UserMailer.new_account(self).deliver_later }

  generates_token_for :password_reset, expires_in: PASSWORD_RESET_TOKEN_DURATION do
    password_salt&.last(10)
  end

  memoize def online? = sessions
    .active
    .exists?

  def disable_otp
    otp_regenerate_secret
    otp_regenerate_backup_codes
    self.otp_enabled = false
    save
  end

  def to_s
    full_name.presence || email
  end

  private

  def secure_password_challenge
    return unless password_challenge
    return unless password_digest_was
    return if BCrypt::Password.new(password_digest_was).is_password?(password_challenge)

    errors.add(:password_challenge)
  end
end

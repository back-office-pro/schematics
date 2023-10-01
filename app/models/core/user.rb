# frozen_string_literal: true

class User < Schematics::ApplicationRecord
  PASSWORD_RESET_TOKEN_DURATION = 2.hours.freeze

  after_create_commit { Schematics::UserMailer.new_account(self).deliver_later }
  attribute :remember_me, :boolean
  attribute :time_zone, default: -> { ::Configuration.time_zone }
  attribute :locale, default: -> { ::Configuration.locale }
  validate :secure_password_challenge
  delegate :admin?, to: :role

  memoize def online? = sessions
    .active
    .exists?

  def password_reset_token_expired?
    return false unless confirmed?

    PASSWORD_RESET_TOKEN_DURATION.ago.after?(reset_password_sent_at)
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

# frozen_string_literal: true

class User < Schematics::ApplicationRecord
  PASSWORD_RESET_TOKEN_DURATION = 2.hours.freeze

  after_create_commit { Schematics::UserMailer.new_account(self).deliver_later }
  attribute :remember_me, :boolean
  attribute :time_zone, default: -> { ::Configuration.time_zone }
  attribute :locale, default: -> { ::Configuration.locale }
  delegate :admin?, to: :role

  def confirmed?
    password_digest.present?
  end

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
end

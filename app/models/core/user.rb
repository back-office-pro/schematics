# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::User < Schematics::ApplicationRecord
  NEW_ACCOUNT_TOKEN_DURATION = 24.hours.freeze
  ONE_TIME_PASSWORD_DURATION = 10.minutes.freeze

  attribute :time_zone, default: -> { ::Configuration.time_zone_with_fallback }
  attribute :locale, default: -> { ::Configuration.locale }

  store_accessor :preferences,
                 :sidebar_toggled,
                 :theme,
                 prefix: true

  validate :secure_password_challenge

  delegate :admin?, to: :role
  delegate :chars, to: :otp_code, prefix: true

  after_create_commit :deliver_new_account_mailer

  generates_token_for :new_account, expires_in: NEW_ACCOUNT_TOKEN_DURATION do
    password_salt&.last(10)
  end

  generates_token_for :one_time_password, expires_in: ONE_TIME_PASSWORD_DURATION do
    otp_last_at
  end

  memoize def online? = sessions
    .active
    .exists?

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
    .new_account(self)
    .deliver_later
end

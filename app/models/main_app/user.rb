# frozen_string_literal: true

module MainApp
  module User
    extend ActiveSupport::Concern

    ONLINE_DELAY = 15.minutes.freeze

    prepended do
      after_create :regenerate_password_reset_token
      after_create { Schematics::UserMailer.new_account(self).deliver_later }
      scope :online, -> { where(last_seen_at: ONLINE_DELAY.ago..) }
    end

    def online?
      last_seen_at < ONLINE_DELAY.ago
    end
  end
end

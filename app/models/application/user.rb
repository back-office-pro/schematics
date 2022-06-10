# frozen_string_literal: true

module Application
  module User
    extend ActiveSupport::Concern

    PASSWORD_RESET_TOKEN_DURATION = 2.hours.freeze

    prepended do
      after_create { Schematics::UserMailer.new_account(self).deliver_later }
      attribute :remember_me, :boolean
      attribute :time_zone, default: Rails.configuration.time_zone
    end

    def admin?
      role == ::Role.admin
    end

    def confirmed?
      password_digest.present?
    end

    def online?
      @online ||= sessions.active.exists?
    end

    def password_reset_token_expired?
      return false unless confirmed?

      PASSWORD_RESET_TOKEN_DURATION.ago.after?(reset_password_sent_at)
    end

    def to_s
      super.presence || email
    end

    def typeahead_history(model, name)
      TypeaheadHistoryQuery.call(searches, model, name)
    end
  end
end

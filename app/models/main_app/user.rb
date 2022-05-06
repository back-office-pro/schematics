# frozen_string_literal: true

module MainApp
  module User
    extend ActiveSupport::Concern

    PASSWORD_RESET_TOKEN_DURATION = 2.hours.freeze
    SEARCH_HISTORY_LIMIT = 5

    prepended do
      after_create { Schematics::UserMailer.new_account(self).deliver_later }
      attribute :remember_me, :boolean
    end

    def admin?
      role == ::Role.admin
    end

    def online?
      @online ||= sessions.active.exists?
    end

    def confirmed?
      password_digest.present?
    end

    def password_reset_token_expired?
      return false unless confirmed?

      PASSWORD_RESET_TOKEN_DURATION.ago.after?(reset_password_sent_at)
    end

    def time_zone
      super || Rails.configuration.time_zone
    end

    def to_s
      super.presence || email
    end

    def search_history
      searches
        .where(model: nil)
        .where
        .not(query: nil)
        .order(created_at: :desc)
        .limit(SEARCH_HISTORY_LIMIT)
        .load_async
        .pluck(:query)
        .uniq
    end

    def typeahead_history(model, name)
      searches
        .where(model:, query: nil)
        .order(created_at: :desc)
        .limit(SEARCH_HISTORY_LIMIT)
        .load_async
        .pluck(:filters)
        .pluck(name)
        .uniq
        .compact
    end
  end
end

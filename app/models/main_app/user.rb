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
      @online ||= sessions.exists?(updated_at: ::Session::ONLINE_DELAY.ago..)
    end

    def password_reset_token_expired?
      return false unless password_digest

      PASSWORD_RESET_TOKEN_DURATION.ago.after?(reset_password_sent_at)
    end

    def search_history
      searches
        .where(model: nil)
        .where
        .not(query: nil)
        .order(created_at: :desc)
        .limit(SEARCH_HISTORY_LIMIT)
        .pluck(:query)
        .uniq
    end

    def typeahead_history(model, name)
      searches
        .where(model:, query: nil)
        .order(created_at: :desc)
        .limit(SEARCH_HISTORY_LIMIT)
        .pluck(:filters)
        .pluck(name)
        .uniq
        .compact
    end
  end
end

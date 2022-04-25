# frozen_string_literal: true

module MainApp
  module Session
    extend ActiveSupport::Concern

    ONLINE_DELAY = 15.minutes.freeze

    prepended do
      scope :online, -> { where(updated_at: ONLINE_DELAY.ago..) }
    end

    def safe
      user
        .sessions
        .where
        .not(id:)
        .exists?(ip:, user_agent:)
    end

    def login!(*)
      self
    end
  end
end

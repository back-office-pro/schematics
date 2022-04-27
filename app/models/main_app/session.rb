# frozen_string_literal: true

module MainApp
  module Session
    extend ActiveSupport::Concern

    ONLINE_DELAY = 15.minutes.freeze

    prepended do
      scope :online, -> { where(updated_at: ONLINE_DELAY.ago..) }
      scope :with_user_permissions, -> { includes(user: { role: :permissions }) }
      scope :with_user_avatar, lambda {
        includes(user: { avatar_attachment: { blob: :variant_records } })
      }
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

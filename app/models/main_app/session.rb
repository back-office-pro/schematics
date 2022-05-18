# frozen_string_literal: true

module MainApp
  module Session
    extend ActiveSupport::Concern

    ACTIVE_DELAY = 15.minutes.freeze

    prepended do
      scope :active, -> { where(updated_at: ACTIVE_DELAY.ago..).load_async }
      scope :with_user_permissions, -> { includes(user: { role: :permissions }) }
      scope :with_user_drafts, -> { includes(user: :drafts) }
      scope :with_user_avatar, lambda {
        includes(user: { avatar_attachment: { blob: :variant_records } })
      }
    end

    def active? = ACTIVE_DELAY
      .ago
      .before?(updated_at)

    def login!(*) = self

    def safe? = user
      .sessions
      .where
      .not(id:)
      .exists?(ip:, user_agent:)
  end
end

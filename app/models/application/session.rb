# frozen_string_literal: true

module Application
  module Session
    extend ActiveSupport::Concern

    ACTIVE_DELAY = 15.minutes.freeze

    prepended do
      scope :active, ActiveQuery
      scope :authorized_by, AuthorizedByQuery
      scope :with_user_permissions, -> { preload(user: { role: :permissions }) }
      scope :with_user_drafts, -> { preload(user: :drafts) }
      scope :with_user_avatar, lambda {
        preload(user: { avatar_attachment: { blob: :variant_records } })
      }
    end

    def active? = ACTIVE_DELAY
      .ago
      .before?(updated_at)

    def login!(user)
      self.class.create!(ip:, user_agent:, user:)
    end

    def safe? = user
      .sessions
      .where
      .not(id:)
      .exists?(ip:, user_agent:)
  end
end

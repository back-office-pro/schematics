# frozen_string_literal: true

module Application
  module Session
    extend ActiveSupport::Concern

    ACTIVE_DELAY = 15.minutes.freeze

    prepended do
      scope :active, ActiveQuery
      scope :authorized_by, AuthorizedByQuery
      scope :with_user_groups, -> { preload(user: { groups: :string_translations }) }
      scope :with_user_drafts, -> { preload(user: :drafts) }
      scope :with_user_slugs, -> { preload(user: :slugs) }
      scope :with_user_permissions, lambda {
        preload(user: { role: %i[string_translations permissions] })
      }
      scope :with_user_avatar, lambda {
        preload(user: { avatar_attachment: { blob: :variant_records } })
      }
    end

    def login!(user)
      case user
      when self.user
        self
      else
        self.class.create!(ip:, user_agent:, user:) # impersonate case
      end
    end

    def touch!(request)
      return unless request.format.html?

      update!(updated_at: ::Time.current)
    end
  end
end

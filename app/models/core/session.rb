# frozen_string_literal: true

module Core
  # :reek:MissingSafeMethod
  class Session < Schematics::ApplicationRecord
    ACTIVE_DELAY = 15.minutes.freeze

    scope :active, Sessions::ActiveQuery
    scope :authorized_by, Sessions::AuthorizedByQuery
    scope :with_user_slugs, -> { preload(user: :slugs) }
    scope :with_user_user_groups_name, -> { preload(user: { user_groups: :string_translations }) }
    scope :with_user_role_permissions, -> { preload(user: { role: :permissions }) }
    scope :with_user_role_name, -> { preload(user: { role: :string_translations }) }

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

      update!(updated_at: Time.current)
    end
  end
end

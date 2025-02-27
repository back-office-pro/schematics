# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Core
  module Session
    extend ActiveSupport::Concern

    ACTIVE_DELAY = 15.minutes.freeze

    prepended do
      scope :active, Sessions::ActiveQuery
      scope :authorized_by, Sessions::AuthorizedByQuery
      scope :with_user_slugs, -> { includes(user: :slugs) }
      scope :with_user_teams_name, -> { includes(user: { teams: :string_translations }) }
      scope :with_user_role_permissions, -> { includes(user: { role: :permissions }) }
      scope :with_user_role_name, -> { includes(user: { role: :string_translations }) }

      after_create_commit :sudo!

      generates_token_for :access_token, expires_in: Schematics::AuthToken::ACCESS_TOKEN_DURATION do
        id
      end

      generates_token_for :refresh_token, expires_in: Schematics::AuthToken::REFRESH_TOKEN_DURATION do # rubocop:disable Layout/LineLength
        created_at
      end
    end

    class_methods do
      def decode_access_token(token, *)
        generated_token_verifier
          .verified(token, purpose: "Demo::Session\naccess_token\n600")
          .first
      end
    end

    def login!(user)
      case user
      when self.user
        self
      else
        self.class.create!(ip:, user_agent:, user:) # impersonate case
      end
    end

    def touch!(request, *)
      unstale.update!(updated_at: Time.current) if request.format.html?
    end

    def sudo?
      sudo_at&.after?(ACTIVE_DELAY.ago)
    end

    def sudo! # rubocop:disable Obsession/Rails/PrivateCallback
      update!(sudo_at: Time.current)
    end
  end
end

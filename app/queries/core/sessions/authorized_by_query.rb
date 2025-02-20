# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Sessions
    class AuthorizedByQuery < Schematics::ApplicationQuery
      def call(access_token, id)
        with_slugs
          .with_user_avatar
          .with_user_teams_name
          .with_user_role_permissions
          .with_user_role_name
          .with_user_slugs
          .with_record_drafts
          .where(id: access_token)
          .or(active.where(id:))
          .load_async
      end
    end
  end
end

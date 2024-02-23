# frozen_string_literal: true

module Core
  module Sessions
    class AuthorizedByQuery < Schematics::ApplicationQuery
      def call(auth_token, id)
        with_slugs
          .with_user_avatar
          .with_user_user_groups_name
          .with_user_role_permissions
          .with_user_role_name
          .with_user_user_drafts
          .with_user_slugs
          .where(id: auth_token)
          .or(active.where(id:))
          .load_async
      end
    end
  end
end

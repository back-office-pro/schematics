# frozen_string_literal: true

module Application
  module Session
    class AuthorizedByQuery < Schematics::ApplicationQuery
      def call(auth_token, id)
        preload(:slugs)
          .preload(user: :slugs)
          .with_user_avatar
          .with_user_permissions
          .with_user_drafts
          .where(auth_token:)
          .or(active.where(id:))
          .load_async
      end
    end
  end
end

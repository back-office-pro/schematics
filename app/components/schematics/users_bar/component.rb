# frozen_string_literal: true

module Schematics
  module UsersBar
    class Component < ApplicationComponent
      LIMIT = 9

      def initialize(users:)
        super
        @users = users[0...LIMIT]
        @other_users = users[LIMIT..]
      end

      def title
        @other_users
          .map(&:full_name)
          .join('<br>')
      end
    end
  end
end

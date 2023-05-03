# frozen_string_literal: true

module Core
  module Charts
    class AccessibleByRoleQuery < Schematics::ApplicationQuery
      def call(role)
        where
          .missing(:roles)
          .or(where(roles: [role]))
      end
    end
  end
end

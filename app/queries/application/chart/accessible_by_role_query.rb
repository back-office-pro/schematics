# frozen_string_literal: true

module Application
  module Chart
    class AccessibleByRoleQuery < Schematics::ApplicationQuery
      def call(role)
        where
          .missing(:roles)
          .or(where(roles: [role]))
      end
    end
  end
end

# frozen_string_literal: true

module MainApp
  module Chart
    class AccessibleByRoleQuery < Schematics::ApplicationQuery
      def call(role)
        left_joins(:roles).where(roles: [role, nil])
      end
    end
  end
end

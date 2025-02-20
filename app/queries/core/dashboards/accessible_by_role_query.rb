# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Dashboards
    class AccessibleByRoleQuery < Schematics::ApplicationQuery
      def call(role)
        where
          .missing(:roles)
          .or(where(roles: [role]))
      end
    end
  end
end

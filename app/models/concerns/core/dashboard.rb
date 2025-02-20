# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Dashboard
    extend ActiveSupport::Concern

    prepended do
      scope :accessible_by_role, Dashboards::AccessibleByRoleQuery
    end

    def icon
      :user_lock if roles.any?
    end
  end
end

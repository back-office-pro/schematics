# frozen_string_literal: true

module Core
  module Dashboard
    extend ActiveSupport::Concern

    prepended do
      scope :accessible_by_role, Dashboards::AccessibleByRoleQuery
    end

    def icon
      ::Role.entity.icon if roles.any?
    end
  end
end

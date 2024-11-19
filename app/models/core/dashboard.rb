# frozen_string_literal: true

class Dashboard < Schematics::ApplicationRecord
  scope :accessible_by_role, ::Core::Dashboards::AccessibleByRoleQuery

  def icon
    Role.entity.icon if roles.any?
  end
end

# frozen_string_literal: true

class Dashboard < Schematics::ApplicationRecord
  scope :accessible_by_role, ::Core::Dashboards::AccessibleByRoleQuery
end

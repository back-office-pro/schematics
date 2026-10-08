# frozen_string_literal: true

class ::Dashboard < Schematics::ApplicationRecord
  scope :accessible_by_role, ::Core::Dashboards::AccessibleByRoleQuery

  def icon
    :user_lock if roles.any?
  end
end

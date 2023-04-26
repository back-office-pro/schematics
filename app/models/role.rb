# frozen_string_literal: true

class Role < Schematics::ApplicationRecord
  class << self
    def admin = first
  end

  def admin? = eql?(self.class.admin)

  def permission_ids
    return super if persisted?

    Permission.features.ids
  end
end

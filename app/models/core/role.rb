# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::Role < Schematics::ApplicationRecord
  class << self
    def admin = first_or_initialize
  end

  def admin? = eql?(self.class.admin)

  def permission_ids
    return super if persisted?

    ::Core::Permissions::FeaturesQuery.call.ids
  end
end

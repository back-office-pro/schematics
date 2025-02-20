# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Role
    extend ActiveSupport::Concern

    class_methods do
      def admin = first_or_initialize
    end

    def admin? = eql?(self.class.admin)

    def permission_ids
      return super if persisted?

      Permissions::FeaturesQuery.call.ids
    end
  end
end

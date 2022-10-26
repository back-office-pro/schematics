# frozen_string_literal: true

module Application
  module Role
    extend ActiveSupport::Concern

    class_methods do
      def admin = find_by(name: 'Admin')
    end

    def permission_ids
      return super if persisted?

      ::Permission.features.ids
    end
  end
end

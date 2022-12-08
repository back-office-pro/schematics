# frozen_string_literal: true

module Application
  module Role
    extend ActiveSupport::Concern

    class_methods do
      def admin = first
    end

    def admin? = eql?(self.class.admin)

    def permission_ids
      return super if persisted?

      mod::Permission.features.ids
    end
  end
end

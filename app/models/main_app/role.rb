# frozen_string_literal: true

module MainApp
  module Role
    extend ActiveSupport::Concern

    class_methods do
      def admin
        @admin ||= find_by(name: 'Admin')
      end
    end
  end
end

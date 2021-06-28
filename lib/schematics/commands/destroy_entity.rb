# frozen_string_literal: true

module Schematics
  module Commands
    class DestroyEntity < Command
      def execute
        [
          "rails destroy scaffold #{name} --skip-migration --skip-resource-route",
          "rails destroy rspec:feature #{name}",
          "rails destroy fixtures #{name}",
          "rails destroy locales #{name}",
          "rails generate migration drop_#{table_name.pluralize} #{migratable_attributes}",
          "rails 'schematics:permissions:destroy[#{class_name}]'"
        ]
      end

      private

      def migratable_attributes
        super.map(&:to_s).join(' ')
      end
    end
  end
end

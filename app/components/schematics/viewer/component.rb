module Schematics
  module Viewer
    class Component < ::ViewComponent::Base
      delegate :fa_icon, :current_ability, to: :helpers
      delegate :can?, to: :current_ability
      delegate :klass, to: :@resources
      delegate :entity, to: :klass
      delegate :icon, to: :entity

      class << self
        def create(resources:)
          case resources.klass.entity.viewer
          when :table
            Table::Component.new(resources: resources)
          when :grid
            Table::Component.new(resources: resources)
          when :calendar
            Table::Component.new(resources: resources)
          when :tree
            Table::Component.new(resources: resources)
          when :inbox
            Table::Component.new(resources: resources)
          end
        end
      end

      def initialize(resources:)
        super
        @resources = resources
      end
    end
  end
end

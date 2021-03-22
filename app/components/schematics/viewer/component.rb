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
            Grid::Component.new(resources: resources)
          when :calendar # rubocop:disable Lint/DuplicateBranch
            Table::Component.new(resources: resources)
          when :tree # rubocop:disable Lint/DuplicateBranch
            Table::Component.new(resources: resources)
          when :inbox # rubocop:disable Lint/DuplicateBranch
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

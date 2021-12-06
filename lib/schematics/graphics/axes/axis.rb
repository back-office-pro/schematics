# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Graphics
    module Axes
      class Axis
        delegate :icon, :class_name, to: :@entity
        delegate :to_sql, to: :field
        attr_reader :agregate, :field

        class << self
          def build(entity, agregate:, field: nil)
            field = entity.find_field_by_name(field)
            new(entity, agregate, field)
          end
        end

        def initialize(entity, agregate, field)
          @entity = entity
          @agregate = agregate
          @field = field
        end

        def title
          title_array = []
          title_array << I18n.t(
            @agregate.to_sym,
            scope: 'schematics.dashboard.home.graphics.agregate',
            default: nil
          )
          if @field.present?
            title_array << model_class.human_attribute_name(@field.name).pluralize.downcase
          end
          title_array.compact
        end

        def to_sql
          @field&.to_sql || :all
        end

        def model_class
          class_name.constantize
        end
      end
    end
  end
end

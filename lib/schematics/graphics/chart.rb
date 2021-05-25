# frozen_string_literal: true

require 'schematics/graphics/axes/x'
require 'schematics/graphics/axes/y'

module Schematics
  module Graphics
    class Chart
      delegate :icon, :class_name, to: :@entity
      attr_reader :x, :y

      class << self
        def create(schema, entity:, type:, x:, y:) # rubocop:disable Naming/MethodParameterName
          entity = schema.find_entity_by_name(entity)
          x_axis = Axes::X.create(entity, **x)
          y_axis = Axes::Y.create(entity, **y)
          new(entity, type, x_axis, y_axis)
        end
      end

      def initialize(entity, type, x_axis, y_axis)
        @entity = entity
        @type = type
        @x = x_axis
        @y = y_axis
      end

      def type
        :"#{@type}_chart"
      end

      def icon
        {
          'line' => :chart_line,
          'pie' => :chart_pie,
          'bar' => :chart_bar,
          'area' => :chart_area,
          'scatter' => :chart_scatter,
          'column' => :analytics,
          'geo' => :globe,
        }[@type]
      end

      def title
        [@y.title, I18n.t('schematics.dashboard.home.graphics.by'), @x.title].join(' ')
      end

      def joins
        [
          x.field&.try(:preload),
          y.field&.try(:preload),
        ].compact.flatten
      end

      def as_json
        class_name
          .constantize
          .joins(joins)
          .send(x.agregate.to_sym, x.to_sql)
          .send(y.agregate.to_sym, y.to_sql)
          .map do |key, value|
            [x.field&.format(key) || key, y.field&.format(value) || value]
          end
          .to_h
      end
    end
  end
end

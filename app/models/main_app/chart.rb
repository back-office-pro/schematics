# frozen_string_literal: true

module MainApp
  module Chart
    extend ActiveSupport::Concern

    prepended do
      delegate :entity, to: :model_class, allow_nil: true, private: true
      delegate :find_field_by_name, to: :entity, allow_nil: true
    end

    def type
      :"#{kind}_chart"
    end

    def icon
      return :exclamation_triangle unless model_class

      {
        line: :chart_line,
        pie: :chart_pie,
        bar: :chart_bar,
        area: :chart_area,
        scatter: :chart_scatter,
        column: :analytics,
        geo: :globe
      }[kind.to_sym]
    end

    def to_s
      return ::I18n.t('errors.virtuals.no_method', name: model) unless model_class

      [ytitle, ::I18n.t('by'), xtitle].join(' ')
    end

    def as_json # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return unless model_class

      model_class
        .joins(joins)
        .public_send(x_agregate.to_sym, entity_x_field&.to_sql || :all)
        .public_send(y_agregate.to_sym, entity_y_field&.to_sql || :all)
        .to_h do |key, value|
          [entity_x_field&.format(key) || key, entity_y_field&.format(value) || value]
        end
    end

    def xtitle
      return unless model_class
      return unless entity_x_field

      model_class
        .human_attribute_name(entity_x_field.name)
        .downcase
    end

    def ytitle
      return unless model_class

      [
        y_agregate_formatted,
        ::I18n.t('of'),
        (model_class.human_attribute_name(entity_y_field.name).pluralize.downcase if entity_y_field), # rubocop:disable Layout/LineLength
        (::I18n.t('of') if entity_y_field),
        model_class.model_name.human.downcase.pluralize
      ].compact.join(' ')
    end

    def suffix
      entity_y_field.try(:unit)
    end

    def model_class
      model.safe_constantize
    end

    private

    def entity_x_field
      x_field && find_field_by_name(x_field.split('#').last)
    end

    def entity_y_field
      y_field && find_field_by_name(y_field.split('#').last)
    end

    def joins
      [
        entity_x_field.try(:preload),
        entity_y_field.try(:preload)
      ].compact.flatten.uniq
    end
  end
end

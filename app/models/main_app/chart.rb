# frozen_string_literal: true

module MainApp
  module Chart
    extend ActiveSupport::Concern

    prepended do
      delegate :entity, to: :model_class, allow_nil: true, private: true
      delegate :find_field_by_name, to: :entity, allow_nil: true
      scope :accessible_by_role, ->(role) { left_joins(:roles).where(roles: [role, nil]) }
    end

    def type
      :"#{kind}_chart"
    end

    def icon
      return :triangle_exclamation unless model_class

      {
        line: :chart_line,
        pie: :chart_pie,
        bar: :chart_bar,
        area: :chart_area,
        scatter: :chart_scatter,
        column: :chart_column,
        geo: :globe
      }[kind.to_sym]
    end

    def to_s
      return ::I18n.t('errors.virtuals.no_method', name: model) unless model_class

      [ytitle, ::I18n.t('by'), xtitle&.downcase].compact.join(' ')
    end

    def serializable_hash(*)
      return unless model_class

      model_class
        .joins(joins)
        .public_send(entity_x_field.group_method, entity_x_field.to_sql)
        .public_send(agregate.to_sym, entity_y_field&.to_sql || :all)
        .to_h do |key, value|
          [entity_x_field.format(key), entity_y_field&.format(value) || value]
        end
    rescue ActiveRecord::StatementInvalid
      {}
    end

    def xtitle
      return unless model_class
      return unless entity_x_field

      model_class.human_attribute_name(entity_x_field.name)
    end

    def ytitle
      return unless model_class

      [
        agregate_formatted,
        ::I18n.t('of'),
        (model_class.human_attribute_name(entity_y_field.name).pluralize.downcase if entity_y_field), # rubocop:disable Layout/LineLength
        (::I18n.t('of') if entity_y_field),
        model_class.human_name_plural
      ].compact.join(' ')
    end

    def suffix
      entity_y_field.try(:unit)
    end

    def css_id
      "chart-#{id}"
    end

    def filename
      to_s.parameterize
    end

    def border_width
      (%w[line area].include?(kind) && 1) || 0
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

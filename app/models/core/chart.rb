# frozen_string_literal: true

class Chart < Schematics::ApplicationRecord
  delegate :entity, to: :model_class, allow_nil: true, private: true
  delegate :find_field_by_name, to: :entity, allow_nil: true
  scope :accessible_by_role, ::Core::Charts::AccessibleByRoleQuery

  class << self
    def api = find_or_initialize_by(model: 'ApiRequest')
  end

  def border_width
    (%w[line area].include?(kind) && 1) || 0
  end

  def col_size = self
    .class
    .sizes
    .transform_values { _1.next * 3 }
    .fetch(size)

  def max_col_size = [12, col_size * 2].min

  def filename
    to_s.parameterize
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

  def model_class
    model.safe_constantize
  end

  def serialized_json(*) # rubocop:disable Metrics/CyclomaticComplexity
    return unless model_class

    model_class
      .eager_load(joins)
      .public_send(entity_x_field.group_method, entity_x_field.to_sql)
      .public_send(aggregate.to_sym, entity_y_field&.to_sql || :all)
      .to_h do |key, value|
        [entity_x_field.format(key), entity_y_field&.format(value) || value]
      end
  rescue ActiveRecord::StatementInvalid
    nil
  end

  alias cached_serialized_json serialized_json

  def suffix
    entity_y_field.try(:unit)
  end

  def to_s
    return I18n.t('errors.virtuals.name', name: model) unless model_class

    [ytitle, I18n.t('by'), xtitle&.downcase].compact.join(' ')
  end

  def type = :"#{kind}_chart"

  def xtitle
    return unless model_class
    return unless entity_x_field

    model_class.human_attribute_name(entity_x_field.name)
  end

  def ytitle
    return unless model_class

    [
      aggregate_formatted,
      I18n.t('of'),
      (model_class.human_attribute_name(entity_y_field.name).pluralize.downcase if entity_y_field),
      (I18n.t('of') if entity_y_field),
      model_class.human_name_plural
    ].compact.join(' ')
  end

  private

  def entity_x_field
    x_field && find_field_by_name(x_field.split('#').last)
  end

  def entity_y_field
    y_field && find_field_by_name(y_field.split('#').last)
  end

  def joins = [
    entity_x_field.try(:preload),
    entity_y_field.try(:preload)
  ].compact.flatten.uniq
end

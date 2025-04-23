# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ::Chart < Schematics::ApplicationRecord
  include Schematics::Measurable

  attribute :color, default: -> { ::Configuration.theme_color }

  class << self
    def api = find_or_initialize_by(model: 'APIRequest')
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

  def colors = color
    .dup
    .paint
    .palette
    .analogous(as: :hex)

  def serialized_json(*) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    suppress(ActiveRecord::StatementInvalid) do
      model_class
        &.preload_all
        &.where(created_at: period_range)
        &.public_send(entity_x_field.group_method, entity_x_field.to_sql)
        &.public_send(aggregate.to_sym, entity_y_field&.to_sql || :all)
        &.to_h do |key, value|
          [entity_x_field.format(key), entity_y_field&.format(value) || value]
        end
    end
  end

  alias cached_serialized_json serialized_json

  def suffix
    entity_y_field.try(:unit)
  end

  def to_s
    return I18n.t('errors.triggers.name', name: model) unless model_class

    [ytitle, (I18n.t('per') if xtitle), xtitle&.downcase, period_title].compact.join(' ')
  end

  def type = :"#{kind}_chart"

  def xtitle
    return unless model_class
    return unless entity_x_field

    model_class.human_attribute_name(entity_x_field.name)
  end

  def ytitle = title_for(entity_y_field)

  private

  def entity_y_field = find_entity_field(y_field)

  def entity_x_field = find_entity_field(x_field)
end

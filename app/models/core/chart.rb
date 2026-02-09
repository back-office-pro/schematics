# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class ::Chart < Schematics::ApplicationRecord
  include Schematics::Measurable

  attribute :color, default: -> { ::Configuration.theme_color }

  class << self
    def api = find_or_initialize_by(model: 'APIRequest')
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

  def serialized_json(*) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    suppress(ActiveRecord::StatementInvalid) do
      model_class
        &.preload_all
        &.where(created_at: period_range)
        &.public_send(entity_x_field.group_method, entity_x_field.to_sql)
        &.public_send(aggregate.to_sym, entity_y_field&.to_sql || :all)
        &.transform_keys(&entity_x_field.method(:format))
    end
  end

  alias cached_serialized_json serialized_json

  def to_s
    return I18n.t('errors.triggers.name', name: model) unless model_class

    [ytitle, (I18n.t('per') if xtitle), xtitle&.downcase, period_title].compact.join(' ')
  end

  def xtitle
    return unless model_class
    return unless entity_x_field

    model_class.human_attribute_name(entity_x_field.name)
  end

  def ytitle = title_for(entity_y_field)

  def entity_y_field = find_entity_field(y_field)

  private

  def entity_x_field = find_entity_field(x_field)
end

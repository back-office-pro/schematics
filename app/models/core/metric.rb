# frozen_string_literal: true

class Metric < Schematics::ApplicationRecord
  delegate :entity, to: :model_class, allow_nil: true, private: true
  delegate :find_field_by_name, to: :entity, allow_nil: true
  delegate :to_sql, :format, to: :entity_field, allow_nil: true

  scope :accessible_by_role, ::Core::Metrics::AccessibleByRoleQuery

  def model_class
    model.safe_constantize
  end

  def icon
    entity&.icon || :triangle_exclamation
  end

  def to_s
    title || I18n.t('errors.virtuals.name', name: model)
  end

  memoize def value(range = period_range)
    model_class
      &.preload_all
      &.where(created_at: range)
      &.public_send(aggregate.to_sym, to_sql || :all)
  rescue ActiveRecord::StatementInvalid
    nil
  end

  def value_formatted
    format(value) || value || '-'
  end

  def exceeded?
    value.public_send(comparator_sign, threshold)
  end

  def trend
    value.to_f <=> value(trend_range).to_f
  end

  def trend_progress
    ((value.to_f - value(trend_range).to_f) / value(trend_range).to_f)
  end

  private

  def period_range
    return ..Time.current unless period

    1.public_send(period).ago..
  end

  def trend_range
    2.public_send(period || :weeks).ago..1.public_send(period || :week).ago
  end

  def entity_field
    field && find_field_by_name(field.split('#').last)
  end

  def title
    return unless model_class

    [
      aggregate_formatted,
      I18n.t('of'),
      (model_class.human_attribute_name(entity_field.name).pluralize.downcase if entity_field),
      (I18n.t('of') if entity_field),
      model_class.human_name_plural,
      (I18n.t('by') if period),
      period_formatted&.downcase
    ].compact.join(' ')
  end

  def comparator_sign
    ActiveModel::Validations::Comparability::COMPARE_CHECKS[comparator.to_sym]
  end
end

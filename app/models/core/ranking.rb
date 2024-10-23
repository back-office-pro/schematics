# frozen_string_literal: true

class Ranking < Schematics::ApplicationRecord
  delegate :entity, to: :model_class, allow_nil: true, private: true
  delegate :find_field_by_name, to: :entity, allow_nil: true, private: true

  scope :accessible_by_role, ::Core::Rankings::AccessibleByRoleQuery

  def model_class
    model.safe_constantize
  end

  def icon
    entity&.icon || :triangle_exclamation
  end

  def values
    model_class
      &.preload_all
      &.where(created_at: period_range)
      &.group(entity_model_field.to_sql)
      &.public_send(aggregate.to_sym, entity_aggregate_field&.to_sql || :all)
  #rescue ActiveRecord::StatementInvalid
  #  []
  end

  def to_s
    return I18n.t('errors.virtuals.name', name: model) unless model_class

    [aggregate_title, I18n.t('by'), model_title&.downcase].compact.join(' ')
  end

  def model_title
    return unless model_class
    return unless entity_model_field

    model_class.human_attribute_name(entity_model_field.name)
  end

  def aggregate_title
    return unless model_class

    [
      aggregate_formatted,
      I18n.t('of'),
      (model_class.human_attribute_name(entity_aggregate_field.name).pluralize.downcase if entity_aggregate_field),
      (I18n.t('of') if entity_aggregate_field),
      model_class.human_name_plural,
      (I18n.t('by') if period),
      period_formatted&.downcase
    ].compact.join(' ')
  end

  private

  def period_range
    return ..Time.current unless period

    1.public_send(period).ago..
  end

  def entity_model_field
    model_field && find_field_by_name(model_field.split('#').last)
  end

  def entity_aggregate_field
    aggregate_field && find_field_by_name(aggregate_field.split('#').last)
  end
end

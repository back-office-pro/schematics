# frozen_string_literal: true

class Ranking < Schematics::ApplicationRecord
  include ::Core::Measurable

  scope :accessible_by_role, ::Core::Rankings::AccessibleByRoleQuery

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

    [
      aggregate_title,
      I18n.t('by'),
      model_title&.downcase,
      (I18n.t('since') if period),
      period_formatted&.downcase
    ].compact.join(' ')
  end

  def model_title
    return unless model_class
    return unless entity_model_field

    model_class.human_attribute_name(entity_model_field.name)
  end

  def aggregate_title = title_for(entity_aggregate_field)

  private

  def entity_model_field = find_entity_field(model_field)

  def entity_aggregate_field = find_entity_field(aggregate_field)
end

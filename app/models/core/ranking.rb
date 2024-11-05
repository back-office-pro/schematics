# frozen_string_literal: true

class Ranking < Schematics::ApplicationRecord
  include ::Core::Measurable

  delegate :to_sql, :name, to: :entity_field, allow_nil: true, private: true
  scope :accessible_by_role, ::Core::Rankings::AccessibleByRoleQuery

  memoize def resources(ability)
    model_class
      &.preload_all
      &.accessible_by(ability)
      &.where(created_at: period_range)
      &.order(to_sql => :desc)
      &.limit(size)
  rescue ActiveRecord::StatementInvalid
    []
  end

  def field_name_formatted = :"#{name}_formatted"

  def to_s
    title || I18n.t('errors.virtuals.name', name: model)
  end

  private

  def title
    return unless model_class

    [
      (model_class.human_attribute_name(name) if entity_field),
      (I18n.t('of') if entity_field),
      model_class.human_name_plural,
      period_title
    ].compact.join(' ')
  end

  def entity_field = find_entity_field(field)
end

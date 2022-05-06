# frozen_string_literal: true

module MainApp
  module Stat
    extend ActiveSupport::Concern

    prepended do
      delegate :entity, to: :model_class, allow_nil: true, private: true
      delegate :icon, :find_field_by_name, to: :entity, allow_nil: true
      delegate :to_sql, :format, to: :entity_field, allow_nil: true
      scope :accessible_by_role, -> { left_joins(:roles).where(roles: [_1, nil]).load_async }
    end

    def to_s
      title || ::I18n.t('errors.virtuals.no_method', name: model)
    end

    def value_formatted
      format(value) || '-'
    end

    def model_class
      model.safe_constantize
    end

    private

    def entity_field
      field && find_field_by_name(field.split('#').last)
    end

    def value
      model_class&.public_send(agregate.to_sym, to_sql || :all)
    rescue ActiveRecord::StatementInvalid
      nil
    end

    def title
      return unless model_class

      [
        agregate_formatted,
        ::I18n.t('of'),
        (model_class.human_attribute_name(entity_field.name).pluralize.downcase if entity_field),
        (::I18n.t('of') if entity_field),
        model_class.human_name_plural
      ].compact.join(' ')
    end
  end
end

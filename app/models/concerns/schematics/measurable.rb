# frozen_string_literal: true

module Schematics
  module Measurable
    extend ActiveSupport::Concern

    included do
      delegate :entity, to: :model_class, allow_nil: true, private: true
      delegate :find_field_by_name, to: :entity, allow_nil: true, private: true
    end

    def model_class
      model.safe_constantize
    end

    def icon
      entity&.icon || :triangle_exclamation
    end

    protected

    def period_range
      return ..Time.current unless period

      1.public_send(period).ago..
    end

    def period_title
      return unless period

      [I18n.t('since'), period_formatted.downcase].join(' ')
    end

    def title_for(field)
      return unless model_class

      [
        aggregate_formatted,
        I18n.t('of'),
        (model_class.human_attribute_name(field.name).pluralize(I18n.locale).downcase if field),
        (I18n.t('of') if field),
        model_class.human_name_plural
      ].compact.join(' ')
    end

    def find_entity_field(field)
      field && find_field_by_name(field.split('#').last)
    end
  end
end

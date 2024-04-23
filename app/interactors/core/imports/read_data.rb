# frozen_string_literal: true

module Core
  module Imports
    class ReadData
      include Interactor
      VALUES_SEPARATOR = ';'

      delegate :import, to: :context, private: true
      delegate :model_class, :file, :model, to: :import, private: true
      delegate :entity, :i18n_scope, to: :model_class, private: true
      delegate :fillable_elements, to: :entity, private: true

      before { context.data = Concurrent::Hash.new }

      def call
        CSV.foreach(filepath, headers: true).with_index(1) do |row, line|
          context.data[line] = convert_row(row.to_h.compact)
        end
      end

      private

      def filepath = ::ActiveStorage::Blob
        .service
        .path_for(file.key)

      def convert_row(row)
        row.to_h do |key, value|
          [
            transform_key(key) || key.parameterize(separator: '_').to_sym,
            transform_value(transform_key(key), value) || value
          ]
        end
      end

      def transform_key(key)
        attributes_translations
          &.invert
          &.dig(key)
      end

      def transform_value(key, value) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        return unless value

        case field = fillable_elements.find { _1.name == key.to_s }
        when Schematics::Associations::HasAndBelongsToMany
          value
            .split(VALUES_SEPARATOR)
            .map(&method(:association_value).curry.call(field))
        when Schematics::Attributes::Association
          association_value(field, value)
        when Schematics::Attributes::Enum
          enums_translations
            &.dig(field.name.to_sym)
            &.invert
            &.dig(value)
        when Schematics::Attributes::Country
          ISO3166::Country
            .find_country_by_any_name(value)
            &.alpha2
        when Schematics::Attributes::Mime
          Mime::Type
            .lookup_by_extension(value.downcase)
            &.__send__(:string)
        when Schematics::Attributes::Array, Schematics::Attributes::Flag
          value.split(VALUES_SEPARATOR)
        end
      end

      def attributes_translations
        ::I18n
          .t(model.underscore.to_sym, scope: [i18n_scope, :attributes])
          .transform_values { _1.try(:fetch, :other) || _1 }
      end

      def enums_translations
        ::I18n.t(model.underscore.to_sym, scope: [i18n_scope, :enums])
      end

      def association_value(field, value)
        case field.descriptor.field
        when Schematics::Behaviours::Translatable
          field
            .model_class
            .i18n
            .eager_load(field.descriptor.joins)
            .find_by(field.descriptor.name => value)
        else
          field
            .model_class
            .eager_load(field.descriptor.joins)
            .find_by("#{field.descriptor.to_sql} = ?", value)
        end
      end
    end
  end
end

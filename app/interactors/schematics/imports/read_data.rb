# frozen_string_literal: true

require 'csv'

module Schematics
  module Imports
    class ReadData
      include Interactor
      delegate :import, to: :context, private: true
      delegate :model_class, :file, :model, to: :import, private: true
      delegate :entity, :i18n_scope, to: :model_class, private: true

      before { context.data = Concurrent::Hash.new }

      def call
        CSV.foreach(filepath, headers: true).with_index(1) do |row, line|
          context.data[line] = convert_row(row.to_h)
        end
      end

      private

      def filepath = ::ActiveStorage::Blob
        .service
        .path_for(file.key)

      def convert_row(row)
        row.to_h do |key, value|
          [transform_key(key), transform_value(transform_key(key), value)]
        end
      end

      def transform_key(key)
        i18n_translations&.invert&.dig(key) || key.parameterize(separator: '_')
      end

      def transform_value(key, value) # rubocop:disable Metrics/CyclomaticComplexity
        field = entity.find_field_by_name(key.to_s)
        case field
        when Schematics::Attributes::Association
          field
            .model_class
            .joins(field.descriptor.joins)
            .find_by("#{field.descriptor.to_sql} = ?", value)
        when Schematics::Attributes::Enum
          i18n_translations&.dig(field.name.pluralize.to_sym)&.invert&.dig(value) ||
            value.parameterize(separator: '_')
        when Schematics::Attributes::Country
          field.collection.to_h[value] || value.parameterize(separator: '_')
        when Schematics::Virtuals::Virtual
          nil
        else
          value
        end
      end

      def i18n_translations
        @i18n_translations ||= ::I18n
                               .t('.')
                               .dig(i18n_scope, :attributes, model.underscore.to_sym)
      end
    end
  end
end

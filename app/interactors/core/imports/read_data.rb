# frozen_string_literal: true

require 'csv'

module Core
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
          [
            transform_key(key) || key.parameterize(separator: '_'),
            transform_value(transform_key(key), value) || value
          ]
        end
      end

      def transform_key(key)
        translations
          &.invert
          &.dig(key)
      end

      def transform_value(key, value) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        return unless value

        field = entity.find_field_by_name(key.to_s)
        case field
        when Schematics::Attributes::Association
          field
            .model_class
            .joins(field.descriptor.joins)
            .find_by("#{field.descriptor.to_sql} = ?", value)
        when Schematics::Attributes::Enum
          translations
            &.dig(field.name.pluralize.to_sym)
            &.invert
            &.dig(value)
        when Schematics::Attributes::Country
          ISO3166::Country
            .find_country_by_any_name(value)
            &.alpha2
        when Schematics::Attributes::TimeZone
          value
            .split
            .second
        when Schematics::Attributes::Mime
          Mime::Type
            .lookup_by_extension(value.downcase)
            &.__send__(:string)
        end
      end

      def translations
        @translations ||= ::I18n.t model.underscore.to_sym, scope: [i18n_scope, :attributes]
      end
    end
  end
end

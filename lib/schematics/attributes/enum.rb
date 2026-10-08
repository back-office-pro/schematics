# frozen_string_literal: true

module Schematics
  module Attributes
    class Enum < Attribute
      include Behaviours::Migratable
      include Behaviours::Indexable
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Enumerable

      def available_options = super.push(
        Options::Values
      )

      def collection = super.sort

      def database_type = 'integer'

      def format(value)
        value && translate(
          value.to_sym,
          default: value.humanize,
          scope: [:activerecord, :enums, entity.name, name]
        )
      end

      memoize def enum_values
        values.map { |value| Options::EnumValue.new(enum: self, value:) }
      end

      def enum_type = [entity.class_name, name.camelize].join

      def openai_description = 'An attribute which represents an enumeration'

      def icon = :list_ol

      def to_str
        if values.any?
          if options.default
            <<~RUBY
              enum :#{name},
                   #{to_h},
                   prefix: true,
                   validate: { allow_blank: #{allow_blank} },
                   default: #{options.default.to_json}
            RUBY
          else
            <<~RUBY
              enum :#{name},
                   #{to_h},
                   prefix: true,
                   validate: { allow_blank: #{allow_blank} }
            RUBY
          end
        else
          <<~RUBY
            enum :#{name}, prefix: true, validate: { allow_blank: #{allow_blank} }
          RUBY
        end
      end

      protected

      def to_h = values
        .map(&:to_sym)
        .map
        .with_index
        .to_h
    end
  end
end

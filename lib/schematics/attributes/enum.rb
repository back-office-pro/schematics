# frozen_string_literal: true

module Schematics
  module Attributes
    class Enum < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable
      include Behaviours::Enumerable

      def type
        'integer'
      end

      def open_api_type
        :integer
      end

      def to_str
        if options.default
          <<~RUBY
            enum #{@name}: #{to_h}, _prefix: true, _default: "#{default}"
          RUBY
        else
          <<~RUBY
            enum #{@name}: #{to_h}, _prefix: true
          RUBY
        end
      end

      def format(value)
        value && translate(
          value.to_sym,
          default: value.humanize,
          scope: [:activerecord, :attributes, @entity.class_name.underscore, @name.pluralize]
        )
      end

      def icon
        :list_ol
      end

      private

      def to_h
        values
          .map(&:to_sym)
          .map
          .with_index
          .to_h
      end
    end
  end
end

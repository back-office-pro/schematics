# frozen_string_literal: true

module Schematics
  module Attributes
    class Enum < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Enumerable

      def database_type = 'integer'
      def collection = super.sort
      def icon = :list_ol

      def to_str
        if options.default
          <<~RUBY
            enum :#{name}, #{to_h}, prefix: true, default: "#{default}"
          RUBY
        else
          <<~RUBY
            enum :#{name}, #{to_h}, prefix: true
          RUBY
        end
      end

      def format(value)
        value && translate(
          value.to_sym,
          default: value.humanize,
          scope: [:activerecord, :attributes, entity.name, name.pluralize]
        )
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

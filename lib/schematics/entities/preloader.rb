# frozen_string_literal: true

module Schematics
  module Entities
    class Preloader
      delegate :preloadable_elements,
               :preloadable_virtuals,
               :association_attributes,
               to: :@entity,
               private: true

      def initialize(entity)
        @entity = entity
      end

      def joins = preloadable_virtuals
        .flat_map(&:preload)
        .compact
        .uniq

      def includes = preloadable_elements
        .flat_map(&:preload)
        .compact
        .uniq

      def to_str = first_level_scopes
        .concat(second_level_scopes)
        .join

      private

      def first_level_scopes = preloadable_elements
        .grep_v(Attributes::RichText)
        .grep_v(Attributes::Attachments)
        .map { |element| [element.name, Array.wrap(element.preload)] }
        .reject { _2.empty? }
        .map { |name, preload| scope_to_str(name, preload) }

      def second_level_scopes = association_attributes
        .reject(&:polymorphic?)
        .map do |attribute|
          attribute
            .inverse_entity
            .preloadable_elements
            .map { |element| second_level_scope_array(attribute, element) }
            .reject { _2.values.first.empty? }
            .map { |name, preload| scope_to_str(name, preload) }
        end

      def scope_to_str(name, preload)
        <<~RUBY
          scope :with_#{name}, -> { preload(#{preload}) }
        RUBY
      end

      def second_level_scope_array(attribute, element)
        [
          "#{attribute.name}_#{element.name}",
          { attribute.name.to_sym => Array.wrap(element.preload) }
        ]
      end
    end
  end
end

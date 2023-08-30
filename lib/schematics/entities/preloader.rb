# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module Schematics
  module Entities
    class Preloader
      delegate :preloadable_elements,
               :association_attributes,
               :virtuals,
               to: :@entity,
               private: true

      def initialize(entity)
        @entity = entity
      end

      def joins = virtuals
        .flat_map(&:preload)
        .compact
        .uniq

      def includes = preloadable_elements
        .grep_v(Associations::HasMany)
        .grep_v(Associations::HasManyThrough)
        .flat_map(&:preload)
        .compact
        .uniq

      def to_str = first_level_scopes
        .concat(second_level_scopes)
        .join

      private

      # :reek:FeatureEnvy
      def first_level_scopes = preloadable_elements
        .grep_v(Attributes::RichText)
        .grep_v(Attributes::Attachment)
        .select { _1.preload.present? }
        .map { scope_to_str(_1.name, Array.wrap(_1.preload), _1.eager_loading_method) }

      # :reek:FeatureEnvy
      def second_level_scopes = association_attributes
        .reject(&:polymorphic?)
        .map do |attribute|
          attribute
            .inverse_entity
            .preloadable_elements
            .select { _1.preload.present? }
            .map do |element|
              scope_to_str(
                "#{attribute.name}_#{element.name}",
                { attribute.name.to_sym => Array.wrap(element.preload) },
                element.eager_loading_method
              )
            end
        end

      def scope_to_str(name, preload, eager_loading_method)
        <<~RUBY
          scope :with_#{name}, -> { #{eager_loading_method}(#{preload}) }
        RUBY
      end
    end
  end
end

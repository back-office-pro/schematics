# frozen_string_literal: true

module Schematics
  module Resources
    class Cache
      include Interactor
      delegate :entity, to: '@resource.class', private: true

      before do
        @resource = context.resource
      end

      def call
        cached_keys.each do |key|
          Rails.cache.write(prefixed(key), @resource.public_send(key))
        end
      end

      private

      def prefixed(key)
        [
          @resource.class.name.underscore.pluralize,
          (@resource.id unless entity.is_a?(Entities::Singleton)),
          key
        ].compact.join(':')
      end

      def cached_keys
        entity
          .attributes
          .select(&:cached?)
          .map(&:name)
      end
    end
  end
end

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
        cached_keys
          .select { @resource.try("#{_1}_previously_changed?") }
          .each do |key|
            Rails.cache.write("#{@resource.cache_key}/#{key}", @resource.public_send(key))
          end
      end

      private

      def cached_keys
        entity
          .attributes
          .select(&:cached?)
          .map(&:name)
      end
    end
  end
end

# frozen_string_literal: true

module Schematics
  module Resources
    class Cache
      include Interactor
      delegate :resource, to: :context, private: true
      delegate :cache_key, to: :resource, private: true
      delegate :entity, to: 'resource.class', private: true

      def call
        cached_keys
          .select { resource.try("#{_1}_previously_changed?") }
          .each do |key|
            Rails.cache.write("#{cache_key}/#{key}", resource.public_send(key))
          end
      end

      private

      def cached_keys = entity
        .attributes
        .select(&:cached?)
        .map(&:name)
    end
  end
end

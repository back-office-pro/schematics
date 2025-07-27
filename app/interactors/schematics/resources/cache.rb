# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Resources
    class Cache
      include Interactor

      delegate :resource, to: :context, private: true
      delegate :cache_key, to: :resource, private: true
      delegate :cached_attributes, to: 'resource.class', private: true

      def call = cached_attributes
        .select(&method(:changed?))
        .each(&method(:write_to_cache))

      private

      def changed?(attribute)
        resource.try("#{attribute}_previously_changed?")
      end

      def write_to_cache(attribute)
        Rails.cache.write("#{cache_key}/#{attribute}", resource.public_send(attribute))
      end
    end
  end
end

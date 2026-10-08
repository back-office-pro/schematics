# frozen_string_literal: true

module Schematics
  module Resources
    class Cache
      include Interactor

      delegate :resource, to: :context, private: true
      delegate :cache_key, to: :resource, private: true

      def call = resource
        .class
        .cached_attributes
        .each(&method(:delete_from_cache))

      private

      def delete_from_cache(attribute)
        Rails.cache.delete("#{cache_key}/#{attribute}")
      end
    end
  end
end

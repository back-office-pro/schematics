# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Serializable
    extend ActiveSupport::Concern

    def cached_serialized_json(options = nil)
      Rails.cache.fetch [cache_key_with_version, __method__, options].join('/') do
        serialized_json(options)
      end
    end

    def serialized_json(options = nil)
      JSONSerializer.new(self, options).content
    end

    def serializable_hash(options = nil)
      return super unless options

      cached_serialized_json(options)
    end
  end
end

# frozen_string_literal: true

module Schematics
  module Serializable
    extend ActiveSupport::Concern

    def serialized_json(options = nil)
      Rails.cache.fetch("#{cache_key_with_version}/serialized_json_with_#{options}") do
        JsonSerializer
          .new(self, options)
          .content
      end
    end

    def serializable_hash(options = nil)
      return super unless options

      serialized_json(options)
    end
  end
end

# frozen_string_literal: true

module Schematics
  module ResourcesHelper
    def polymorphic_path(record_or_hash_or_array, options = {})
      case record_or_hash_or_array
      when Class
        route_resources_path(
          resource: record_or_hash_or_array.to_s.underscore,
          **options
        )
      when Array

      else
        route_resource_path(
          resource: record_or_hash_or_array.model_name.route_key,
          id: record_or_hash_or_array.id,
          **options
        )
      end
    end
  end
end

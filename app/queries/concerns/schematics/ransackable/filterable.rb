# frozen_string_literal: true

module Schematics
  module Ransackable
    module Filterable
      extend ActiveSupport::Concern

      def parse_filter_params(params)
        params
          .deep_flatten
          .transform_keys { entity.find_field_by_name(_1)&.search_query || _1 }
      end
    end
  end
end

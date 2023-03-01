# frozen_string_literal: true

module Schematics
  module Searchkickable
    module Filterable
      extend ActiveSupport::Concern

      def parse_filter_params(params)
        params.transform_values(&method(:cast_filter_value))
      end

      private

      def cast_comparison(value)
        return value.to_date if value.match?(/\d{4}-\d{2}-\d{2}/)

        value.to_f
      end

      def cast_filter_value(value)
        case value
        in 'true'
          true
        in 'false'
          false
        in gte:
          { gte: cast_comparison(gte) }
        in lte:
          { lte: cast_comparison(lte) }
        else
          { ilike: "%#{value}%" }
        end
      end
    end
  end
end

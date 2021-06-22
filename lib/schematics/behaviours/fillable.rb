# frozen_string_literal: true

module Schematics
  module Behaviours
    module Fillable
      delegate :default, to: :options

      def permitted_params
        column_name.to_sym
      end

      def permitted_json_params
        permitted_params
      end

      def json_default
        default
      end
    end
  end
end

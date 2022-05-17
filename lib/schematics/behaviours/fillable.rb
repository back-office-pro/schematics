# frozen_string_literal: true

module Schematics
  module Behaviours
    module Fillable
      delegate :default, :readonly?, to: :options

      def json_default = default

      def permitted_json_params = permitted_params

      def permitted_params = column_name.to_sym
    end
  end
end

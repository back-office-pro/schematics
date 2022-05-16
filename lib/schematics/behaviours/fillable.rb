# frozen_string_literal: true

module Schematics
  module Behaviours
    module Fillable
      delegate :default, :readonly?, to: :options

      def permitted_params = column_name.to_sym
      def permitted_json_params = permitted_params
      def json_default = default
    end
  end
end

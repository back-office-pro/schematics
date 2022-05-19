# frozen_string_literal: true

module Schematics
  module Behaviours
    module Enumerable
      delegate :values, to: :options

      def collection = values
        .map { [format(_1), _1] }
        .tap { _1.unshift ['', ''] unless required? }

      def default = values.first

      def inclusion_list = values

      def validators = super.merge(
        inclusion: { in: inclusion_list },
        allow_blank:
      )
    end
  end
end

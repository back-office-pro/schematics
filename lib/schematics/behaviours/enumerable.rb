# frozen_string_literal: true

module Schematics
  module Behaviours
    module Enumerable
      delegate :values, to: :options

      def collection = values.map { [format(_1), _1] }

      def default = values.first

      def validators = super.merge(
        inclusion: { in: values },
        allow_blank:
      )
    end
  end
end

# frozen_string_literal: true

module Schematics
  module Behaviours
    module Enumerable
      delegate :values, to: :options

      def default = values.first

      def validators
        super.merge({ inclusion: { in: values }, allow_blank: })
      end

      def collection
        values
          .map { [format(_1), _1] }
          .tap { _1.unshift ['', ''] unless required? }
      end
    end
  end
end

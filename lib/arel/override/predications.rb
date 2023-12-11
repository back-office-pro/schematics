# frozen_string_literal: true

module Arel
  module Override
    module Predications
      def any(other)
        Nodes::Equality.new(
          Nodes.build_quoted(other, self),
          Nodes::NamedFunction.new('ANY', [self])
        )
      end
    end
  end
end

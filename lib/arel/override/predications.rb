# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Arel
  module Override
    module Predications
      def any(other)
        Nodes::NamedFunction.new('CAST', [as('TEXT')]).matches("%#{other}%")
      end
    end
  end
end

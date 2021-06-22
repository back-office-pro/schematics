# frozen_string_literal: true

module Schematics
  module Behaviours
    module Renderable
      delegate :readonly?, to: :options

      def format(value)
        value
      end
    end
  end
end

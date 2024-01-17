# frozen_string_literal: true

module SassC
  module Override
    module Engine
      def load_paths = super.flatten
    end
  end
end

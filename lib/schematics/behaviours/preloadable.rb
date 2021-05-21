# frozen_string_literal: true

module Schematics
  module Behaviours
    module Preloadable
      def preload
        name.to_sym
      end
    end
  end
end

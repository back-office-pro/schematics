# frozen_string_literal: true

module Schematics
  module Behaviours
    module Preloadable
      def preload = name.to_sym

      def eager_loading_method = :includes
    end
  end
end

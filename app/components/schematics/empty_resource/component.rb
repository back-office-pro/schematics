# frozen_string_literal: true

module Schematics
  module EmptyResource
    class Component < ApplicationComponent
      def initialize(suggestions: [])
        super
        @suggestions = suggestions
      end
    end
  end
end

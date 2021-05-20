module Schematics
  module EmptyResource
    class Component < ApplicationComponent
      delegate :search_path, to: 'Schematics::Engine.routes.url_helpers'

      def initialize(suggestions: [])
        super
        @suggestions = suggestions
      end
    end
  end
end

module Schematics
  module EmptyResource
    class Component < ::ViewComponent::Base
      delegate :fa_icon, to: :helpers
      delegate :search_path, to: 'Schematics::Engine.routes.url_helpers'

      def initialize(suggestions: [])
        @suggestions = suggestions
      end
    end
  end
end

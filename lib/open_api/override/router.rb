# frozen_string_literal: true

module OpenApi
  module Override
    module Router
      delegate :routes, to: 'Schematics::Engine.routes', prefix: :schematics, private: true
      delegate :routes, to: 'Rails.application.routes', prefix: :rails, private: true
      delegate :reload_routes!, to: 'Rails.application', private: true

      def routes
        @routes ||= begin
          reload_routes!
          ActionDispatch::Routing::RoutesInspector.new(rails_routes).format(formatter) +
            ActionDispatch::Routing::RoutesInspector.new(schematics_routes).format(formatter)
        end
      end

      def reload!
        instance_variable_set(:@routes, nil)
        instance_variable_set(:@routes_list, nil)
      end

      private

      def formatter = ActionDispatch::Routing::ConsoleFormatter::Sheet.new
    end
  end
end

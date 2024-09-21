# frozen_string_literal: true

module OpenApi
  module Override
    module Router
      SEMAPHORE = Mutex.new.freeze

      delegate :reload_routes!, to: '::Rails.application', private: true
      delegate :available_locales, :default_locale, to: ::I18n, private: true

      def routes
        SEMAPHORE.synchronize do
          @routes ||= ActionDispatch::Routing::RoutesInspector.new(rails_routes).format(formatter) +
                      ActionDispatch::Routing::RoutesInspector.new(schematics_routes).format(formatter) # rubocop:disable Layout/LineLength
        end
      end

      def reload!
        SEMAPHORE.synchronize do
          reload_routes!
          instance_variable_set(:@routes, nil)
          instance_variable_set(:@routes_list, nil)
        end
      end

      private

      def formatter = ActionDispatch::Routing::ConsoleFormatter::Sheet.new

      def rails_routes = ::Rails
        .application
        .routes
        .routes
        .reject(&method(:localized?))

      def schematics_routes = ::Schematics::Engine
        .routes
        .routes
        .reject(&method(:localized?))

      def localized?(route)
        available_locales
          .excluding(default_locale)
          .map(&:to_s)
          .push(nil)
          .include?(route.scope_options[:locale])
      end
    end
  end
end

module Schematics
  module Behaviours
    module Preloadable
      def preload
        [name.to_sym]
      end

      def default_scope
        if preload.any?
          <<~RUBY
            default_scope { #{default_scope_method}(#{preload}) }
          RUBY
        end
      end

      def default_scope_method
        :includes
      end
    end
  end
end

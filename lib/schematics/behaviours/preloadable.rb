module Schematics
  module Behaviours
    module Preloadable
      def includes
        [name.to_sym]
      end

      def joins
        includes
      end

      def default_scope
        if includes.any?
          <<~RUBY
            default_scope { includes(#{includes}) }
          RUBY
        end
      end
    end
  end
end

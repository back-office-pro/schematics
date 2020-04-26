module Schematics
  module Entities
    class Singleton < Entity
      def generate
        [
          super + " --skip-resource-route --skip-test-framework",
          "rails generate singleton_resource_route #{@type}",
        ]
      end

      def model_elements
        super << self
      end

      def to_str
        <<~RUBY
          acts_as_singleton
        RUBY
      end
    end
  end
end

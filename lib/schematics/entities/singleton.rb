module Schematics
  module Entities
    class Singleton < Entity
      def generate_options
        super << "--skip-resource-route"
      end

      def generate
        super << "rails generate singleton_resource_route #{name}"
      end

      def to_str
        super + <<~RUBY
          acts_as_singleton
          class << self
            # Make .all method public for ransack
            public :all
          end
        RUBY
      end
    end
  end
end

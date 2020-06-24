module Schematics
  module Entities
    class Tree < Entity
      def to_str
        super + <<~RUBY
          has_ancestry
        RUBY
      end

      protected

      def default_generators
        super << "rails g migration add_ancestry_to_#{name.pluralize} ancestry:string"
      end
    end
  end
end

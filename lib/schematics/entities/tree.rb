module Schematics
  module Entities
    class Tree < Entity
      def generate
        super << "rails g migration add_ancestry_to_#{name.pluralize} ancestry:string"
      end

      def to_str
        super + <<~RUBY
          has_ancestry
        RUBY
      end
    end
  end
end

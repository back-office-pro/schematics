require 'schematics/entities/entity'

module Schematics
  module Entities
    class Tree < Entity
      def to_str
        super + <<~RUBY # rubocop:disable Style/StringConcatenation
          has_ancestry
        RUBY
      end

      def viewer
        :tree
      end

      protected

      def default_generators
        super << "rails g migration add_ancestry_to_#{name.pluralize} ancestry:string"
      end
    end
  end
end

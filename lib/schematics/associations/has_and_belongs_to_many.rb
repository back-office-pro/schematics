require 'schematics/associations/association'
require 'schematics/behaviours/fillable'

module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Fillable

      def source
        inverse_of.pluralize
      end

      def column_name
        super.pluralize
      end

      def permitted_params
        { super => [] }
      end

      def to_str
        <<~RUBY
          #{type} :#{name}
        RUBY
      end
    end
  end
end

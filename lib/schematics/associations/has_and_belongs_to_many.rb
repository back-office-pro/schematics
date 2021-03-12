require 'schematics/associations/association'
require 'schematics/behaviours/fillable'

module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Fillable

      def name
        belongs_to.name.pluralize
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

      def generator
        <<~SHELL
          rails g migration create_join_table_#{entity.name.pluralize}_#{name} #{entity.name.pluralize} #{name}:join_table_uuid
        SHELL
      end
    end
  end
end

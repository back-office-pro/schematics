require 'schematics/associations/association'
require 'schematics/behaviours/fillable'
require 'active_support/core_ext/module/delegation'

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
          #{type} :#{name}, inverse_of: :#{entity.name}
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

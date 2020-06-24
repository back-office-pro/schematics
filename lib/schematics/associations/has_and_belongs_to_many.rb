module Schematics
  module Associations
    class HasAndBelongsToMany < Association
      include Behaviours::Fillable
      delegate :model_property, :api_param, :column_name, to: :belongs_to

      def name
        belongs_to.name.pluralize
      end

      def permitted_params
        { column_name.pluralize => [] }
      end

      def model_property_type
        @name
      end

      def api_param_type
        "array"
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

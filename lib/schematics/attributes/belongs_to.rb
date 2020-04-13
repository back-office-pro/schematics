module Schematics
  module Attributes
    class BelongsTo < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Preloadable

      attr_accessor :inverse_descriptor

      def migration_options
        super + [:polymorphic, :type]
      end

      def column_name
        super + "_id"
      end

      def association_type
        @options[:type] || @name
      end

      def inverse_association_name
        inverse_association[:name] || @entity.type
      end

      def inverse_association
        @options[:inverse]
      end

      def filter_scope
        super.extends <<~RUBY
          #{@name} { where(#{@name}: #{@name}) }
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            joins(:#{association_type}).
            merge(#{association_type.camelize}.order(#{inverse_descriptor.name}: sort_direction))
          end
        RUBY
      end

      def model_property_type
        association_type.camelize
      end

      def api_param_type
        "integer"
      end

      def to_str
        <<~RUBY
          belongs_to :#{@name}, class_name: '#{model_property_type}', optional: #{!required?}
        RUBY
      end

      def inverse_of_has_one?
        inverse_association[:type] == 'has_one'
      end

      def inverse_of_has_many?
        inverse_association[:type] == 'has_many'
      end

      def create_inverse_association
        Schematics::Associations.const_get(inverse_association[:type].camelize.to_sym).new(self)
      end

      def icon
        :link
      end
    end
  end
end

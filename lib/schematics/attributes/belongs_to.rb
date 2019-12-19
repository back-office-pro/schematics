module Schematics
  module Attributes
    class BelongsTo < Attribute
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
        super + %Q[#{@name} { where(#{@name}: #{@name}) }]
      end

      def sort_scope
        super + %Q[(sort_direction, field) { joins(:#{association_type}).merge(#{association_type.camelize}.order({ field => sort_direction })) }]
      end

      def model_property_type
        association_type.camelize
      end

      def api_param_type
        "integer"
      end

      def to_str
        %Q[belongs_to :#{@name}, class_name: '#{model_property_type}', optional: #{!required?}] 
      end

      def inverse_of_has_one?
        inverse_association[:type] === 'has_one'
      end

      def inverse_of_has_many?
        inverse_association[:type] === 'has_many'
      end

      def create_inverse_association
        "Schematics::Associations::#{inverse_association[:type].camelize}".constantize.new(self)
      end

      def icon
        :link
      end
    end
  end
end

module Schematics
  module Attributes
    class Association < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Preloadable
      include Behaviours::Editable

      attr_accessor :inverse_descriptor
      delegate :icon, to: :entity

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

      def includes
        return [] if association_type == @entity.type # prevent self inclusion
        super
      end

      def search_field
        :"#{name}_#{inverse_descriptor.name}_cont"
      end

      def sort_field
        :"#{name}_#{inverse_descriptor.name}"
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

      def input_type
        :select
      end

      def input_collection
        association_type.camelize.constantize.all.collect do |association|
          [association.id, association.to_s]
        end
      end
    end
  end
end

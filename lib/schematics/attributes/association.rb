module Schematics
  module Attributes
    class Association < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
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
        inverse_association[:name] || @entity.name
      end

      def preload
        return if association_type == @entity.name # prevent self inclusion
        super
      end

      def search_data
        <<~RUBY
          #{name}&.#{inverse_descriptor.name}&.searchize
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
        Associations::Association.create(self, **inverse_association)
      end

      def input_type
        :select
      end

      def input_collection
        association_type.camelize.constantize.all.collect do |association|
          [association.id, association.to_s]
        end
      end

      def weight
        2
      end

      private

      def inverse_association
        @options[:inverse]
      end
    end
  end
end

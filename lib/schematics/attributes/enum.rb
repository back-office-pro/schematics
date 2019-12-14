module Schematics
  module Attributes
    class Enum < Attribute
      attr_accessor :values
      
      def initialize(entity, name, options)
        super(entity, name, { default: 0 })
        @values = options
      end

      def validators
        super.merge(inclusion: { in: @values })
      end

      def type
        "integer"
      end
      
      def api_param_type
        "string"
      end

      def model_property
        [super.sub('property', 'property_list'), @values.to_s].join(', ')
      end

      def api_param
        [super.sub('param', 'param_list'), @values.to_s].join(', ')
      end

      def scope
        super + %Q[#{@name} { where(#{@name}: #{@name}) }]
      end

      def to_str
        %Q[enum #{@name}: #{@values.map(&:to_sym).map.with_index.to_h}]
      end
    end
  end
end

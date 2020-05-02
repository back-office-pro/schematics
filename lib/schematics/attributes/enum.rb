module Schematics
  module Attributes
    class Enum < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Fillable
      include Behaviours::Editable
      include Behaviours::Default::Sortable
      include Behaviours::Default::Filterable

      attr_reader :values

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

      def to_str
        <<~RUBY
          enum #{@name}: #{@values.map(&:to_sym).map.with_index.to_h}, _prefix: true
        RUBY
      end

      def format(value)
        I18n.t value.to_sym,
               default: value.humanize,
               scope: [:activerecord, :attributes, @entity.class_name.underscore, @name.pluralize]
      end

      def icon
        :list_ol
      end

      def input_type
        :select
      end

      def input_collection
        @values.collect { |value| [value, format(value)] }
      end
    end
  end
end

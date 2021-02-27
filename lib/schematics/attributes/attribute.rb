module Schematics
  module Attributes
    class Attribute
      attr_reader :entity, :name

      class << self
        def create(entity, name:, type:, options: {})
          Attributes.const_get(type.camelize.to_sym).new(entity, name, options)
        end

        def created_at(entity)
          create(entity, type: 'date', name: 'created_at')
        end

        def id(entity)
          create(entity, type: 'integer', name: 'id')
        end
      end

      def initialize(entity, name, options)
        @entity = entity
        @name = name
        @options = options
      end

      def type
        self.class.name.demodulize.underscore
      end

      def migration_options
        %i[unique required default]
      end

      def to_s
        [@name, type, @options.slice(*migration_options).to_a].reject(&:empty?).join(':')
      end

      def required?
        @options[:required] || unique?
      end

      def unique?
        @options[:unique]
      end

      def column_name
        @name
      end

      def model_property_type
        api_param_type
      end

      def api_param_type
        type
      end

      def model_property
        <<~RUBY
          property :#{@name.camelize(:lower)},
                   :#{model_property_type},
                   #{required? ? ':required' : ':optional'},
                   "#{@name.humanize}"
        RUBY
      end

      def api_param
        <<~RUBY
          param :form,
          "#{@entity.name.camelize(:lower)}[#{@name.camelize(:lower)}]",
          :#{api_param_type},
          #{required? ? ':required' : ':optional'},
          "#{@name.humanize}"
        RUBY
      end

      def validators
        validators = {}
        validators[:uniqueness] = { case_sensitive: false } if unique?
        validators[:presence] = true if required?
        validators
      end

      def validate
        return if validators.empty?
        <<~RUBY
          validates :#{@name}, #{validators}
        RUBY
      end

      def default
        SecureRandom.base58 if unique?
      end

      def json_default
        default
      end

      def to_sql
        [@entity.name.pluralize, @name].join('.')
      end

      def to_str
        ''
      end

      def weight
        1
      end
    end
  end
end
